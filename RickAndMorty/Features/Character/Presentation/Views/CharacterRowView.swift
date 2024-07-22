//
//  CharacterRowView.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 28.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI
import CachedAsyncImage

struct CharacterRowView: View {
    // MARK: - Public Properties
    
    let url: String
    let name: String
    
    // MARK: - Private Properties
    
    private static let imageSideLength: CGFloat = 80
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            CachedAsyncImage(
                url: url,
                placeholder: { _ in
                    LoaderView(size: .small)
                },
                image: {
                    Image(uiImage: $0)
                        .resizable()
                        .scaledToFill()
                },
                error: { _, _ in
                    Image("rickAndMortyFill")
                        .resizable()
                        .scaledToFill()
                }
            )
            .frame(width: Self.imageSideLength, height: Self.imageSideLength)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Text(name)
                .lineLimit(2)
                .font(.seravek(size: 16))
                .foregroundStyle(.darkOnLight)
                .padding(.leading, 8)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.lightOnDark)
    }
}

// MARK: - Preview

#Preview {
    CharacterRowView(
        url: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        name: "Citadel of Ricks"
    )
}
