//
//  Extension+Optional.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 25.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

extension Optional where Wrapped == Data {
    // MARK: - Public Properties
    
    var convertToString: String? {
        guard let data = self else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
