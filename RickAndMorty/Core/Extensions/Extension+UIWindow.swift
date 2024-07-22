//
//  Extension+UIWindow.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 28.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

extension UIWindow {
    // MARK: - Public Properties
    
    static var userInterfaceStyle: UIUserInterfaceStyle {
        return UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first?
            .windowScene?
            .screen
            .traitCollection
            .userInterfaceStyle ?? .light
    }
}
