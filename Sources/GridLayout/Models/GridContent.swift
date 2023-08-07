//
//  File.swift
//  
//
//  Created by Metin Tarık Kiki on 19.05.2023.
//

import UIKit

public protocol GridContent {
    var cells: [GridLength] { get }
}

public struct Constant: GridContent {
    
    public var cells: [GridLength]
    
    public init(value: CGFloat,
                horizontalAlignment: GridHorizontalAlignment = .fill,
                verticalAlignment: GridVerticalAlignment = .fill,
                margin: UIEdgeInsets = .zero,
                @GridBuilder content: () -> [UIView]) {
        
        cells = [GridLength]()
        
        for view in content() {
            cells.append(.constant(value: value,
                               view: view,
                               horizontalAlignment: horizontalAlignment,
                               verticalAlignment: verticalAlignment,
                               margin: margin))
        }
    }
}

public struct Expanded: GridContent {
    
    public var cells: [GridLength]
    
    public init(value: CGFloat,
                horizontalAlignment: GridHorizontalAlignment = .fill,
                verticalAlignment: GridVerticalAlignment = .fill,
                margin: UIEdgeInsets = .zero,
                @GridBuilder content: () -> [UIView]) {
        
        cells = [GridLength]()
        
        for view in content() {
            cells.append(.expanded(value: value,
                               view: view,
                               horizontalAlignment: horizontalAlignment,
                               verticalAlignment: verticalAlignment,
                               margin: margin))
        }
    }
}

public struct Auto: GridContent {
    
    public var cells: [GridLength]
    
    public init(horizontalAlignment: GridHorizontalAlignment = .fill,
                verticalAlignment: GridVerticalAlignment = .fill,
                maxSize: CGFloat = 0,
                margin: UIEdgeInsets = .zero,
                @GridBuilder content: () -> [UIView]) {
        
        cells = [GridLength]()
        
        for view in content() {
            cells.append(.auto(view: view,
                               horizontalAlignment: horizontalAlignment,
                               verticalAlignment: verticalAlignment,
                               maxSize: maxSize,
                               margin: margin))
        }
    }
}
