//
//  Loading.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 27.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

enum LoadingBackgroundType {
    case transparent
    case material
}

private struct Loading: ViewModifier {
    // MARK: - Public Properties
    
    let isPresented: Binding<Bool>?
    let isLoading: Bool
    let progress: Double?
    let type: LoadingBackgroundType
    
    // MARK: - Body Method
    
    func body(content: Content) -> some View {
        ZStack {
            if isLoading {
                content
                    .disabled(isLoading)
                    .overlay {
                        let isMaterial = type == .material
                        
                        ZStack {
                            transparentFill
                                .if(isMaterial) { view in
                                    view
                                        .background(
                                            .ultraThinMaterial,
                                            in: RoundedRectangle(
                                                cornerRadius: .zero
                                            )
                                        )
                                        .ignoresSafeArea()
                                        .environment(\.colorScheme, .light)
                                }
                            
                            if let progress = progress {
                                LoadingProgressView(progress: progress)
                            } else {
                                LoaderView()
                            }
                            
                            if let isPresented = isPresented, isMaterial {
                                close(isPresented: isPresented)
                            }
                        }
                    }
            } else {
                content
            }
        }
    }
}

// MARK: - Ext. Configure views

extension Loading {
    private var transparentFill: some View {
        Color.clear
            .ignoresSafeArea()
    }
    
    private func close(isPresented: Binding<Bool>) -> some View {
        Button(
            action: {
                isPresented.wrappedValue = false
            },
            label: {
                Image(systemName: "xmark")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.dark)
                    .frame(width: 18, height: 18)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topTrailing
                    )
                    .padding(16)
            }
        )
        .buttonStyle(.plain)
    }
}

// MARK: - Ext. View

extension View {
    func loading(
        isPresented: Binding<Bool>? = nil,
        isLoading: Bool,
        progress: Double? = nil,
        type: LoadingBackgroundType = .material
    ) -> some View {
        modifier(
            Loading(
                isPresented: isPresented,
                isLoading: isLoading,
                progress: progress,
                type: type
            )
        )
    }
}
