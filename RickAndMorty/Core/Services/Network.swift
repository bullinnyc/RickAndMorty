//
//  Network.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 20.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

protocol NetworkProtocol {
    func fetchCharacter(page: Int) -> ProgressPublisherTuple<CharacterResponse>
}

struct Network: NetworkProtocol {
    // MARK: - Private Properties
    
    private let networkManager: NetworkManagerProtocol
    
    // MARK: - Initializers
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    // MARK: - Public Methods
    
    // Character.
    func fetchCharacter(
        page: Int
    ) -> ProgressPublisherTuple<CharacterResponse> {
        let parameters = ["page": String(page)]
        
        let (progress, result): ProgressPublisherTuple<CharacterResponse> =
            networkManager.makeRequest(
                url: Api.character(),
                parameters: parameters
            )
        
        return (progress, result)
    }
}
