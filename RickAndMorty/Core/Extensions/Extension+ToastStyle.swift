//
//  Extension+ToastStyle.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 27.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI
import Toast

extension ToastStyle {
    // MARK: - Public Properties
    
    static var lightAndDark: ToastStyle {
        let isDark = UIWindow.userInterfaceStyle == .dark
        let opacity = 0.98
        
        let textColor: Color = isDark
            ? .dark.opacity(opacity)
            : .light.opacity(opacity)
        
        let backgroundColor: Color = isDark
            ? .light.opacity(opacity)
            : .dark.opacity(opacity)
        
        return ToastStyle(
            titleTextColor: textColor,
            titleTextAlignment: .leading,
            titleFont: .seravekMedium(size: 24),
            titleLineLimit: 1,
            messageTextColor: textColor,
            messageTextAlignment: .leading,
            messageFont: .seravek(size: 16),
            messageLineLimit: 0,
            backgroundColor: backgroundColor,
            cornerRadius: 21,
            imageAlignment: .trailing,
            isImageAnimation: false
        )
    }
}
