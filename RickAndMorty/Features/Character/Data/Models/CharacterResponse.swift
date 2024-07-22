//
//  CharacterResponse.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 20.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

// MARK: - CharacterResponse

struct CharacterResponse: Codable {
    let info: Info
    let results: [CharacterResult]
}

// MARK: - Info

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - CharacterResult

struct CharacterResult: Codable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location

struct Location: Codable {
    let name: String
    let url: String
}

// MARK: - Gender

enum Gender: String, Codable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
}

// MARK: - Status

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
