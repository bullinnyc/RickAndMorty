//
//  CharactersView.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 20.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI
import Toast

struct CharactersView: View {
    // MARK: - Property Wrappers
    
    @EnvironmentObject private var toast: Toast
    
    @StateObject private var charactersViewModel = CharactersViewModel(
        characterUseCase: Injection.shared.getCharacterUseCase()
    )
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if let error = charactersViewModel.error {
                ErrorView(
                    message: error,
                    isLoading: charactersViewModel.isLoading,
                    onRetry: charactersViewModel.fetchCharacter
                )
            } else {
                characters(data: charactersViewModel.сharacterResultEntities)
                    .loading(
                        isLoading: charactersViewModel.isLoading,
                        progress: charactersViewModel.loadingProgress
                    )
            }
        }
        .onAppear(perform: charactersViewModel.fetchCharacter)
    }
}

// MARK: - Ext. Configure views

extension CharactersView {
    private func characters(data: [CharacterResultEntity]) -> some View {
        NavigationStack {
            ZStack {
                Color.lightOnDark
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack {
                        ForEach(data, id: \.self) { value in
                            CharacterRowView(
                                url: value.image,
                                name: value.name
                            )
                            .onAppear {
                                charactersViewModel.onScrolledAtBottom(value)
                            }
                        }
                    }
                    .padding(.top)
                }
                .ignoresSafeArea(edges: .trailing)
                .refreshable {
                    await charactersViewModel.refresh()
                }
                
                if charactersViewModel.isBottomLoading {
                    ProgressView()
                        .padding(.bottom, 24)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .ignoresSafeArea()
                }
            }
            .navigationTitle(Localizable.localized("characters"))
            .onReceive(charactersViewModel.$toastMessage) { newValue in
                guard let newValue = newValue else { return }
                
                toast.show(
                    title: Localizable.localized("error"),
                    message: newValue,
                    style: .lightAndDark
                )
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CharactersView()
        .environmentObject(Toast())
}
