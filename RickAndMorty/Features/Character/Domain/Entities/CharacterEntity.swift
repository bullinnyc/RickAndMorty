//
//  CharacterEntity.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 20.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

// MARK: - CharacterEntity

struct CharacterEntity {
    let info: InfoEntity
    let results: [CharacterResultEntity]
}

// MARK: - InfoEntity

struct InfoEntity {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - CharacterResultEntity

struct CharacterResultEntity: Hashable {
    let id: Int
    let name: String
    let status: StatusEntity
    let species: String
    let type: String
    let gender: GenderEntity
    let origin: LocationEntity
    let location: LocationEntity
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    static func == (
        lhs: CharacterResultEntity, rhs: CharacterResultEntity
    ) -> Bool {
        lhs.id == rhs.id && lhs.created == rhs.created
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(created)
    }
}

// MARK: - LocationEntity

struct LocationEntity {
    let name: String
    let url: String
}

// MARK: - GenderEntity

enum GenderEntity: String {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
}

// MARK: - StatusEntity

enum StatusEntity: String {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
