//
//  Extension+String.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 26.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

typealias Localizable = String.Localizable

extension String {
    // MARK: - Enums
    
    struct Localizable {
        static func localized(_ key: String) -> String {
            String(localized: LocalizationValue(stringLiteral: key))
        }
        
        static func localized(_ key: String, _ args: CVarArg...) -> String {
            String(format: localized(key), arguments: args)
        }
    }
}
