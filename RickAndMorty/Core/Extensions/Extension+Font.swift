//
//  Extension+Font.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 26.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

extension Font {
    // MARK: - Public Methods
    
    static func seravek(size: CGFloat) -> Font {
        custom("Seravek", size: size)
    }
    
    static func seravekMedium(size: CGFloat) -> Font {
        custom("Seravek-Medium", size: size)
    }
}
