//
//  CharacterRepositoryImpl.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 20.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation
import Combine

typealias CharacterEntityTuple = (
    progress: Progress?,
    publisher: AnyPublisher<CharacterEntity, Error>
)

struct CharacterRepositoryImpl: CharacterRepository {
    // MARK: - Private Properties
    
    private let remoteDataSource: CharacterRemoteDataSource
    
    // MARK: - Initializers
    
    init(remoteDataSource: CharacterRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    // MARK: - Public Methods
    
    func fetchCharacter(page: Int) -> CharacterEntityTuple {
        let (progress, publisher) = remoteDataSource.fetchCharacter(page: page)
        
        let entityPublisher = publisher
            .map { CharacterMapper.toEntity(from: $0) }
            .eraseToAnyPublisher()
        
        return (progress, entityPublisher)
    }
}
