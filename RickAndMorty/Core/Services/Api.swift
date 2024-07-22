//
//  Api.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 20.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

struct Api {
    // MARK: - Private Properties
    
    private static var baseUrl = "https://rickandmortyapi.com/api"
    
    // MARK: - Public Methods
    
    static func character() -> String {
        createEndpoint(["character"])
    }
    
    static func location() -> String {
        createEndpoint(["location"])
    }
    
    static func episode() -> String {
        createEndpoint(["episode"])
    }
    
    // MARK: - Private Methods
    
    private static func createEndpoint(_ components: [String]) -> String {
        var components = components
        components.insert(baseUrl, at: 0)
        
        return components.joined(separator: "/")
    }
}
