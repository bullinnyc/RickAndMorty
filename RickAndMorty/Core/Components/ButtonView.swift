//
//  ButtonView.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 25.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct ButtonView: View {
    // MARK: - Private Properties
    
    private let title: String
    private let isLoading: Bool
    private let isDisabled: Bool
    private let action: () -> Void
    
    // MARK: - Initializers
    
    init(
        title: String,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundStyle(.lightOnDark)
                .font(.seravek(size: 22))
                .opacity(isLoading && !isDisabled ? 0 : 1)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 13)
                        .foregroundStyle(isDisabled ? .stone : .lime)
                )
                .overlay {
                    if isLoading, !isDisabled {
                        LoaderView(color: .lightOnDark, size: .small)
                    }
                }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.lightOnDark
            .ignoresSafeArea()
        
        ButtonView(
            title: "Title",
            isLoading: false,
            isDisabled: false,
            action: {}
        )
        .padding(.horizontal)
    }
}
