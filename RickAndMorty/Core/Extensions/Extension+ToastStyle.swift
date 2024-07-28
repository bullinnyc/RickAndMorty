//
//  Extension+ToastStyle.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 27.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import UIKit
import Toast

extension ToastStyle {
    // MARK: - Public Properties
    
    static var lightAndDark: ToastStyle {
        let opacity = 0.98
        let textColor = UIColor.lightOnDark.withAlphaComponent(opacity)
        
        return ToastStyle(
            titleTextColor: textColor,
            titleTextAlignment: .leading,
            titleFont: .seravekMedium(size: 24),
            titleLineLimit: 1,
            messageTextColor: textColor,
            messageTextAlignment: .leading,
            messageFont: .seravek(size: 16),
            messageLineLimit: 0,
            backgroundColor: UIColor.darkOnLight.withAlphaComponent(opacity),
            cornerRadius: 21,
            imageAlignment: .trailing,
            isImageAnimation: false
        )
    }
}
