//
//  LoadingState.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 25.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

enum LoadingState<T> {
    case idle
    case loading(_ progress: Double = .zero)
    case failed(_ error: String)
    case loaded(_ value: T)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        
        return false
    }
}
