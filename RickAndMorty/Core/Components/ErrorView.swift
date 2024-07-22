//
//  ErrorView.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 25.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    // MARK: - Private Properties
    
    private let title: String
    private let message: String
    private let isLoading: Bool
    private let onRetry: () -> Void
    
    // MARK: - Initializers
    
    init(
        title: String = Localizable.localized("error"),
        message: String,
        isLoading: Bool,
        onRetry: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.isLoading = isLoading
        self.onRetry = onRetry
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.lightOnDark
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                let sideLength = geometry.size.height * 0.25
                
                VStack(spacing: 16) {
                    Image("portal")
                        .resizable()
                        .scaledToFill()
                        .frame(width: sideLength, height: sideLength)
                    
                    Text(title)
                        .lineLimit(2)
                        .font(.seravek(size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.tomato)
                        .padding(.top, 34)
                    
                    Text(message)
                        .lineLimit(4)
                        .font(.seravek(size: 18))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.darkOnLight)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            ButtonView(
                title: Localizable.localized("retry"),
                isLoading: isLoading,
                action: onRetry
            )
            .padding(.horizontal)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

// MARK: - Preview

#Preview {
    ErrorView(
        title: "Error",
        message: "Some message",
        isLoading: false,
        onRetry: {}
    )
}
