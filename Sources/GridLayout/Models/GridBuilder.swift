//
//  GridBuilder.swift
//  
//
//  Created by Metin Tarık Kiki on 18.05.2023.
//

import UIKit

@resultBuilder
public struct GridBuilder {
    
    public static func buildBlock(_ components: any GridContentProtocol...) -> [GridContentBase] {
        return components.map( { $0.getInstance() } )
    }
    
    public static func buildBlock(_ components: [any GridContentProtocol]) -> [GridContentBase] {
        return components.map( { $0.getInstance() } )
    }
    
    public static func buildArray(_ components: [[any GridContentProtocol]]) -> [GridContentBase] {
        return components.flatMap( { $0 } ).map( { $0.getInstance() } )
    }
}
