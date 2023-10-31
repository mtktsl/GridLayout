//
//  GridContentProtocol.swift
//  
//
//  Created by Metin Tarık Kiki on 19.05.2023.
//

import UIKit

public protocol GridContentProtocol: AnyObject {
    var cell: GridCell { get }
    
    func calculateSizing(
        boundsSize: CGSize,
        totalExpanded: CGFloat, 
        totalConstant: CGFloat,
        gridType: GridOrientation
    ) -> (cellSize: CGSize, viewSize: CGSize)
    
    func calculateViewWidthForOrthogonalAlignment(
        boundsWidth: CGFloat,
        autoSizingAvailability: Bool
    ) -> CGFloat
    
    func calculateViewHeightForOrthogonalAlignment(
        boundsHeight: CGFloat,
        autoSizingAvailability: Bool
    ) -> CGFloat
    
    func setSpacing(cellSize: CGSize, viewSize: CGSize)
    
    func deactivateAlignmentConstraints()
    func setConstraints(_ constraints: [NSLayoutConstraint])
    
    func horizontalAlignment(_ alignment: GridHorizontalAlignment) -> GridContentProtocol
    func verticalAlignment(_ alignment: GridVerticalAlignment) -> GridContentProtocol
    func margin(_ margin: UIEdgeInsets) -> GridContentProtocol
}

extension GridContentProtocol {
    public func deactivateAlignmentConstraints() {
        NSLayoutConstraint.deactivate(cell.constraints)
    }
    
    public func setConstraints(_ constraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.activate(constraints)
        cell.constraints.append(contentsOf: constraints)
    }
    
    public func horizontalAlignment(_ alignment: GridHorizontalAlignment) -> GridContentProtocol {
        cell.horizontalAlignment = alignment
        return self
    }
    
    public func verticalAlignment(_ alignment: GridVerticalAlignment) -> GridContentProtocol {
        cell.verticalAlignment = alignment
        return self
    }
    
    public func margin(_ margin: UIEdgeInsets) -> GridContentProtocol {
        cell.margin = margin
        return self
    }
}
