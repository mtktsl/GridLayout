//
//  File.swift
//  
//
//  Created by Metin Tarık Kiki on 19.05.2023.
//

import UIKit

public protocol GridContent {
    var cell: GridCell { get }
}

public struct GridConstantCell: GridContent {
    
    public var cell: GridCell
    
    init(cell: GridCell) {
        self.cell = cell
    }
    
    public func horizontalAlignment(_ alignment: GridHorizontalAlignment) -> GridConstantCell {
        cell.horizontalAlignment = alignment
        return self
    }
    
    public func verticalAlignment(_ alignment: GridVerticalAlignment) -> GridConstantCell {
        cell.verticalAlignment = alignment
        return self
    }
    
    public func margin(_ margin: UIEdgeInsets) -> GridConstantCell {
        cell.margin = margin
        return self
    }
}

public struct GridExpandedCell: GridContent {
    
    public var cell: GridCell
    
    init(cell: GridCell) {
        self.cell = cell
    }
    
    public func horizontalAlignment(_ alignment: GridHorizontalAlignment) -> GridExpandedCell {
        cell.horizontalAlignment = alignment
        return self
    }
    
    public func verticalAlignment(_ alignment: GridVerticalAlignment) -> GridExpandedCell {
        cell.verticalAlignment = alignment
        return self
    }
    
    public func margin(_ margin: UIEdgeInsets) -> GridExpandedCell {
        cell.margin = margin
        return self
    }
}

public struct GridAutoCell: GridContent {
    
    public var cell: GridCell
    
    init(cell: GridCell) {
        self.cell = cell
    }
    
    public func horizontalAlignment(_ alignment: GridHorizontalAlignment) -> GridAutoCell {
        cell.horizontalAlignment = alignment
        return self
    }
    
    public func verticalAlignment(_ alignment: GridVerticalAlignment) -> GridAutoCell {
        cell.verticalAlignment = alignment
        return self
    }
    
    public func margin(_ margin: UIEdgeInsets) -> GridAutoCell {
        cell.margin = margin
        return self
    }
    
    public func maxSize(_ maxSize: CGFloat) -> GridAutoCell {
        cell.maxLength = maxSize
        return self
    }
}
