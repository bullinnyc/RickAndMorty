//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 20.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation
import Combine

final class CharactersViewModel: ObservableObject {
    // MARK: - Property Wrappers
    
    @Published private(set) var сharacterResultEntities:
        [CharacterResultEntity] = []
    
    @Published private(set) var loadingProgress: Double = .zero
    @Published private(set) var isLoading = false
    @Published private(set) var isBottomLoading = false
    @Published private(set) var error: String?
    @Published private(set) var toastMessage: String?
    
    // MARK: - Private Properties
    
    private let characterUseCase: CharacterUseCase
    
    private var cancellables: Set<AnyCancellable> = []
    private var isCanLoadNextPage = true
    private var page = 1
    
    private var isFirstPage: Bool {
        page == 1
    }
    
    // MARK: - Initializers
    
    init(characterUseCase: CharacterUseCase) {
        self.characterUseCase = characterUseCase
    }
    
    // MARK: - Public Methods
    
    func fetchCharacter() {
        guard !isLoading || isCanLoadNextPage else { return }
        
        let (progress, data) = characterUseCase.fetchCharacter(page: page)
        
        progress?
            .publisher(for: \.fractionCompleted)
            .subscribe(on: DispatchQueue.dataProcessing)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fractionCompleted in
                guard let self = self, self.isFirstPage else { return }
                self.loadingProgress = fractionCompleted
            }
            .store(in: &cancellables)
        
        data
            .handleEvents(
                receiveSubscription: { _ in
                    Task { @MainActor [weak self] in
                        self?.setLoading(with: true)
                    }
                }
            )
            .catch { error -> AnyPublisher<CharacterEntity, Never> in
                if let networkError = error as? NetworkError {
                    Task { @MainActor [weak self] in
                        guard let self = self else { return }
                        
                        let errorMessage = self.getErrorMessage(networkError)
                        
                        if self.isFirstPage {
                            self.error = errorMessage
                        } else {
                            self.toastMessage = errorMessage
                        }
                        
                        self.setLoading(with: false)
                    }
                }
                
                return Empty(completeImmediately: true).eraseToAnyPublisher()
            }
            .subscribe(on: DispatchQueue.dataProcessing)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.сharacterResultEntities += data.results
                self?.setLoading(with: false)
                self?.finish(with: data.info.count)
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func refresh() async {
        do {
            let data = try await characterUseCase.fetchCharacter(page: 1)
                .publisher
                .awaitSink(&cancellables)
            
            сharacterResultEntities = data.results
            page = 1
            finish(with: data.info.count)
        } catch {
            if let networkError = error as? NetworkError {
                toastMessage = getErrorMessage(networkError)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setLoading(with value: Bool) {
        if isFirstPage {
            isLoading = value
        } else {
            isBottomLoading = value
        }
    }
    
    private func getErrorMessage(_ networkError: NetworkError) -> String {
        switch networkError {
        case .badURL, .transportError, .badResponse:
            return networkError.message
        case .noDecodedData:
            return Localizable.localized("somethingWentWrong")
        }
    }
    
    private func finish(with count: Int) {
        error = nil
        toastMessage = nil
        page += 1
        isCanLoadNextPage = сharacterResultEntities.count != count
    }
}
