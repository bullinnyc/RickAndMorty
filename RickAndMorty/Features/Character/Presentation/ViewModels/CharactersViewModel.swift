//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 20.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation
import Combine

final class CharactersViewModel: ObservableObject {
    // MARK: - Property Wrappers
    
    @Published private(set) var сharacterResultEntities:
        [CharacterResultEntity] = []
    
    @Published private(set) var loadingProgress: Double = .zero
    @Published private(set) var isLoading = false
    @Published private(set) var isBottomLoading = false
    @Published private(set) var error: String?
    @Published private(set) var toastError: String?
    
    // MARK: - Private Properties
    
    private let characterUseCase: CharacterUseCase
    
    private var cancellables: Set<AnyCancellable> = []
    private var isCanLoadNextPage = true
    private var page = 1
    
    private var isFirstPage: Bool {
        page == 1
    }
    
    // MARK: - Initializers
    
    init(characterUseCase: CharacterUseCase) {
        self.characterUseCase = characterUseCase
    }
    
    // MARK: - Public Methods
    
    func fetchCharacter() {
        guard !isLoading || isCanLoadNextPage else { return }
        
        let (progress, data) = characterUseCase.fetchCharacter(page: page)
        
        progress?
            .publisher(for: \.fractionCompleted)
            .subscribe(on: DispatchQueue.dataProcessing)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fractionCompleted in
                guard let self = self, self.isFirstPage else { return }
                self.loadingProgress = fractionCompleted
            }
            .store(in: &cancellables)
        
        data
            .handleEvents(
                receiveSubscription: { _ in
                    Task { @MainActor [weak self] in
                        guard let self = self else { return }
                        
                        if self.isFirstPage {
                            self.isLoading = true
                        } else {
                            self.isBottomLoading = true
                        }
                    }
                }
            )
            .catch { error -> AnyPublisher<CharacterEntity, Never> in
                if let networkError = error as? NetworkError {
                    Task { @MainActor [weak self] in
                        guard let self = self else { return }
                        
                        if self.isFirstPage {
                            self.isLoading = false
                            self.error = networkError.message
                        } else {
                            self.isBottomLoading = false
                            self.toastError = networkError.message
                        }
                    }
                }
                
                return Empty(completeImmediately: true).eraseToAnyPublisher()
            }
            .subscribe(on: DispatchQueue.dataProcessing)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.сharacterResultEntities += data.results
                self?.isLoading = false
                self?.isBottomLoading = false
                self?.finish(data)
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func refresh() async {
        do {
            let data = try await characterUseCase.fetchCharacter(page: 1)
                .publisher
                .awaitSink(&cancellables)
            
            сharacterResultEntities = data.results
            page = 1
            finish(data)
        } catch {
            if let networkError = error as? NetworkError {
                toastError = networkError.message
            }
        }
    }
    
    func onScrolledAtBottom(_ entity: CharacterResultEntity) {
        if сharacterResultEntities.last == entity {
            fetchCharacter()
        }
    }
    
    // MARK: - Private Methods
    
    private func finish(_ data: CharacterEntity) {
        error = nil
        toastError = nil
        page += 1
        isCanLoadNextPage = сharacterResultEntities.count != data.info.count
    }
}
