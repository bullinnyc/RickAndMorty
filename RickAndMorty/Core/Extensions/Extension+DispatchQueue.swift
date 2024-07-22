//
//  Extension+DispatchQueue.swift
//  RickAndMorty
//
//  Created by Dmitry Kononchuk on 27.07.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

extension DispatchQueue {
    // MARK: - Public Properties
    
    static let dataProcessing = DispatchQueue(
        label: "com.rickAndMorty.dataProcessing"
    )
}
