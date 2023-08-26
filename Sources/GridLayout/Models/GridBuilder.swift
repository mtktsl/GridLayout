//
//  File.swift
//  
//
//  Created by Metin Tarık Kiki on 18.05.2023.
//

import UIKit

@resultBuilder
public struct GridBuilder {
    
    public static func buildBlock(_ components: GridContent...) -> [GridCell] {
        return components.map( {$0.cell} )
    }
    
    public static func buildBlock(_ components: [GridCell]...) -> [GridCell] {
        return components.flatMap( { $0 } )
    }
    
    public static func buildArray(_ components: [[GridCell]]) -> [GridCell] {
        return components.flatMap( { $0 } )
    }
}
