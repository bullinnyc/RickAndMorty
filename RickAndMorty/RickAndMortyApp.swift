//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 20.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI
import Toast

@main
struct RickAndMortyApp: App {
    // MARK: - Property Wrappers
    
    @StateObject private var toast = Toast()
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            CharactersView()
                .environmentObject(toast)
        }
    }
}
