//
//  LoadingProgressView.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 26.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct LoadingProgressView: View {
    // MARK: - Public Properties
    
    let progress: Double
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 16) {
            let percentValue = Int(progress * 100)
            
            LoaderView()
            
            Text(Localizable.localized("loading", String(percentValue)))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .font(.seravek(size: 14))
                .foregroundStyle(.dark)
                .frame(width: 90, alignment: .leading)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.lightOnDark
            .ignoresSafeArea()
        
        LoadingProgressView(progress: 0.8)
    }
}
