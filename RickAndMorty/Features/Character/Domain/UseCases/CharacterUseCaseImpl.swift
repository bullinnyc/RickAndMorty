//
//  CharacterUseCaseImpl.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 20.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

protocol CharacterUseCase {
    func fetchCharacter(page: Int) -> CharacterEntityTuple
}

struct CharacterUseCaseImpl: CharacterUseCase {
    // MARK: - Private Properties
    
    private let repository: CharacterRepository
    
    // MARK: - Initializers
    
    init(repository: CharacterRepository) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    
    func fetchCharacter(page: Int) -> CharacterEntityTuple {
        repository.fetchCharacter(page: page)
    }
}
