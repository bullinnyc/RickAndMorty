//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 20.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation
import Combine

typealias ProgressPublisherTuple<T: Codable> = (
    progress: Progress?,
    publisher: AnyPublisher<T, Error>
)

protocol NetworkManagerProtocol {
    func makeRequest<T: Codable>(
        url: String,
        parameters: [String: String],
        httpBody: Data?,
        httpMethod: HttpMethod,
        cachePolicy: URLRequest.CachePolicy,
        httpHeaders: [String: String]?,
        handleResponse: [Int: String]
    ) -> ProgressPublisherTuple<T>
}

extension NetworkManagerProtocol {
    func makeRequest<T: Codable>(
        url: String,
        parameters: [String: String] = [:],
        httpBody: Data? = nil,
        httpMethod: HttpMethod = .get,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        httpHeaders: [String: String]? = nil,
        handleResponse: [Int: String] = [:]
    ) -> ProgressPublisherTuple<T> {
        makeRequest(
            url: url,
            parameters: parameters,
            httpBody: httpBody,
            httpMethod: httpMethod,
            cachePolicy: cachePolicy,
            httpHeaders: httpHeaders,
            handleResponse: handleResponse
        )
    }
}

enum NetworkError: LocalizedError {
    // Invalid request, e.g. invalid URL.
    case badURL(_ message: String = Localizable.localized("badURL"))
    
    // Indicates an error on the transport layer,
    // e.g. not being able to connect to the server.
    case transportError(_ message: Error)
    
    // Received an bad response, e.g. non HTTP result.
    case badResponse(
        _ message: String,
        _ data: Data?,
        _ response: HTTPURLResponse?
    )
    
    // No decoded data, e.g. because it isn’t in the correct format.
    case noDecodedData(_ message: String, _ data: Data?)
    
    var message: String {
        switch self {
        case .badURL(let message):
            return message
        case .transportError(let error):
            return error.localizedDescription
        case .badResponse(let message, _, _):
            return message
        case .noDecodedData(let message, _):
            return message
        }
    }
    
    var data: Data? {
        switch self {
        case .badURL, .transportError:
            return nil
        case .noDecodedData(_, let data):
            return data
        case .badResponse(_, let data, _):
            return data
        }
    }
    
    var response: HTTPURLResponse? {
        switch self {
        case .badURL, .transportError, .noDecodedData:
            return nil
        case .badResponse(_, _, let response):
            return response
        }
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct NetworkManager: NetworkManagerProtocol {
    // MARK: - Public Methods
    
    func makeRequest<T: Codable>(
        url: String,
        parameters: [String: String] = [:],
        httpBody: Data? = nil,
        httpMethod: HttpMethod = .get,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        httpHeaders: [String: String]? = nil,
        handleResponse: [Int: String] = [:]
    ) -> ProgressPublisherTuple<T> {
        let url = parameters.isEmpty
            ? URL(string: url)
            : createQueryUrl(for: url, parameters: parameters)
        
        guard let url = url else {
            return (
                nil,
                Fail(error: NetworkError.badURL()).eraseToAnyPublisher()
            )
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.cachePolicy = cachePolicy
        
        if let httpBody = httpBody {
            request.httpBody = httpBody
        }
        
        if let httpHeaders = httpHeaders {
            for (key, value) in httpHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let sharedPublisher = URLSession.shared
            .dataTaskProgressPublisher(for: request)
        
        let progress = sharedPublisher
            .progress
        
        let result = sharedPublisher
            .publisher
             // Handle transport layer errors.
            .mapError { NetworkError.transportError($0) }
             // Handle response errors.
            .tryMap { element in
                guard let httpResponse = element
                    .response as? HTTPURLResponse else {
                    throw NetworkError.badResponse(
                        Localizable.localized("badResponse"), nil, nil
                    )
                }
                
                let data = element.data
                
                for (code, message) in handleResponse {
                    if httpResponse.statusCode == code {
                        throw NetworkError.badResponse(
                            message, data, httpResponse
                        )
                    }
                }
                
                return data
            }
            // Handle decode errors.
            .tryMap { data in
                let decoder = JSONDecoder()
                
                guard let decode = try? decoder.decode(
                    T.self, from: data
                ) else {
                    throw NetworkError.noDecodedData(
                        Localizable.localized("noDecodedData"),
                        data
                    )
                }
                
                return decode
            }
            .eraseToAnyPublisher()
        
        return (progress, result)
    }
    
    // MARK: - Private Methods
    
    private func createData(with parameters: [String: String]) -> Data? {
        parameters.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
    }
    
    private func createQueryUrl(
        for url: String,
        parameters: [String: String]
    ) -> URL? {
        guard let url = URL(string: url) else { return nil }
        
        var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )
        
        components?.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        return components?.url
    }
}

// MARK: - Ext. URLSession

extension URLSession {
    // MARK: - Typealias
    
    typealias DataTaskProgressPublisherTuple = (
        progress: Progress?,
        publisher: AnyPublisher<DataTaskPublisher.Output, Error>
    )
    
    // MARK: - Public Methods
    
    func dataTaskProgressPublisher(
        for request: URLRequest
    ) -> DataTaskProgressPublisherTuple {
        let progress = Progress(totalUnitCount: 1)
        
        let result = Deferred {
            Future<DataTaskPublisher.Output, Error> { handler in
                let task = self.dataTask(
                    with: request
                ) { data, response, error in
                    if let error = error {
                        handler(.failure(error))
                    } else if let data = data, let response = response {
                        handler(.success((data, response)))
                    }
                }
                
                progress.addChild(task.progress, withPendingUnitCount: 1)
                task.resume()
            }
        }
        .share()
        .eraseToAnyPublisher()
        
        return (progress, result)
    }
}
