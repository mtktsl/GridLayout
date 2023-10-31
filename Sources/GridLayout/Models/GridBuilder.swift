//
//  GridBuilder.swift
//  
//
//  Created by Metin Tarık Kiki on 18.05.2023.
//

import UIKit

@resultBuilder
public struct GridBuilder {
    
    public static func buildBlock(_ components: GridContentProtocol...) -> [GridContentProtocol] {
        return components
    }
    
    public static func buildBlock(_ components: [GridContentProtocol]) -> [GridContentProtocol] {
        return components
    }
    
    public static func buildArray(_ components: [[GridContentProtocol]]) -> [GridContentProtocol] {
        return components.flatMap( { $0 } )
    }
}
