//
//  CharacterMapper.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 20.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

struct CharacterMapper {
    // MARK: - Public Methods
    
    static func toEntity(from content: CharacterResponse) -> CharacterEntity {
        CharacterEntity(
            info: InfoEntity(
                count: content.info.count,
                pages: content.info.pages,
                next: content.info.next,
                prev: content.info.prev
            ),
            results: content.results.map { result in
                CharacterResultEntity(
                    id: result.id,
                    name: result.name,
                    status: toEntity(status: result.status),
                    species: result.species,
                    type: result.type,
                    gender: toEntity(gender: result.gender),
                    origin: toEntity(location: result.origin),
                    location: toEntity(location: result.location),
                    image: result.image,
                    episode: result.episode,
                    url: result.url,
                    created: result.created
                )
            }
        )
    }
    
    // MARK: - Private Methods
    
    private static func toEntity(status: Status) -> StatusEntity {
        switch status {
        case .alive:
            return .alive
        case .dead:
            return .dead
        case .unknown:
            return .unknown
        }
    }
    
    private static func toEntity(gender: Gender) -> GenderEntity {
        switch gender {
        case .male:
            return .male
        case .female:
            return .female
        case .genderless:
            return .genderless
        case .unknown:
            return .unknown
        }
    }
    
    private static func toEntity(location: Location) -> LocationEntity {
        LocationEntity(name: location.name, url: location.url)
    }
}
