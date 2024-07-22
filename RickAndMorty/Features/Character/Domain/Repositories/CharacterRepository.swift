//
//  CharacterRepository.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 20.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

protocol CharacterRepository {
    func fetchCharacter(page: Int) -> CharacterEntityTuple
}
