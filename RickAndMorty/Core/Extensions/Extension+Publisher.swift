//
//  Extension+Publisher.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 21.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
    // MARK: - Public Methods
    
    func awaitSink(
        _ cancellable: inout Set<AnyCancellable>
    ) async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            self
                .subscribe(on: DispatchQueue.dataProcessing)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(with: .failure(error))
                        }
                    },
                    receiveValue: { output in
                        continuation.resume(with: .success(output))
                    }
                )
                .store(in: &cancellable)
        }
    }
}
