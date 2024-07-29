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
        ToastStyle(
            titleTextColor: .tomato,
            titleTextAlignment: .leading,
            titleFont: .seravekMedium(size: 24),
            titleLineLimit: 1,
            messageTextColor: UIColor.lightOnDark,
            messageTextAlignment: .leading,
            messageFont: .seravek(size: 16),
            messageLineLimit: 0,
            backgroundColor: UIColor.darkOnLight.withAlphaComponent(0.98),
            cornerRadius: 21,
            imageAlignment: .trailing,
            isImageAnimation: false
        )
    }
}
