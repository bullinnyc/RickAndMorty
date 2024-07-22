//
//  CharacterRemoteDataSource.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 20.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

protocol CharacterRemoteDataSource {
    func fetchCharacter(page: Int) -> ProgressPublisherTuple<CharacterResponse>
}

struct CharacterRemoteDataSourceImpl: CharacterRemoteDataSource {
    // MARK: - Private Properties
    
    private let network: NetworkProtocol
    
    // MARK: - Initializers
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
    // MARK: - Public Methods
    
    func fetchCharacter(page: Int) -> ProgressPublisherTuple<CharacterResponse> {
        network.fetchCharacter(page: page)
    }
}
