//
//  File.swift
//  
//
//  Created by Metin Tarık Kiki on 18.05.2023.
//

import UIKit

@resultBuilder
public struct GridBuilder {
    
    public static func buildBlock(_ components: GridContent...) -> [GridLength] {
        var result = [GridLength]()
        for content in components {
            result.append(contentsOf: content.cells)
        }
        return result
    }
    
    public static func buildBlock(_ components: [GridLength]) -> [GridLength] {
        return components
    }
    
    public static func buildArray(_ components: [[GridLength]]) -> [GridLength] {
        return components.flatMap({ $0 })
    }
    
    public static func buildBlock(_ components: UIView...) -> [UIView] {
        return components
    }
}
