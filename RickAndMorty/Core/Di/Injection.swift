//
//  Injection.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 24.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

protocol Injectable {
    var network: NetworkProtocol { get }
    func getCharacterUseCase() -> CharacterUseCase
}

final class Injection: Injectable {
    // MARK: - Public Properties
    
    static let shared = Injection()
    
    // MARK: - Private Properties
    
    private(set) lazy var network: NetworkProtocol = {
        Network(networkManager: NetworkManager())
    }()
    
    // MARK: - Private Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func getCharacterUseCase() -> CharacterUseCase {
        let characterRemoteDataSource = CharacterRemoteDataSourceImpl(
            network: network
        )
        
        let characterRepository = CharacterRepositoryImpl(
            remoteDataSource: characterRemoteDataSource
        )
        
        return CharacterUseCaseImpl(repository: characterRepository)
    }
}
