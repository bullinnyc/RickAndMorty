//
//  LoaderView.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 25.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct LoaderView: View {
    // MARK: - Enums
    
    enum Size {
        case small
        case medium
        case large
        
        var value: CGFloat {
            switch self {
            case .small:
                return 20
            case .medium:
                return 40
            case .large:
                return 80
            }
        }
    }
    
    // MARK: - Property Wrappers
    
    @State private var animate = false
    
    // MARK: - Private Properties
    
    private let color: UIColor
    private let size: Size
    
    // MARK: - Initializers
    
    init(color: UIColor = UIColor(.lime), size: Size = .medium) {
        self.color = color
        self.size = size
    }
    
    // MARK: - Body
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                Color(uiColor: color),
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
            .frame(width: size.value, height: size.value)
            .rotationEffect(Angle(degrees: animate ? 360 : 0))
            .animation(
                .linear(duration: 0.8).repeatForever(autoreverses: false),
                value: animate
            )
            .onAppear {
                animate = true
            }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.lightOnDark
            .ignoresSafeArea()
        
        LoaderView()
    }
}
