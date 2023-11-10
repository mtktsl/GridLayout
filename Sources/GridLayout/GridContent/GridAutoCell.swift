//
//  GridAutoCell.swift
//  
//
//  Created by Metin Tarık Kiki on 23.10.2023.
//

import UIKit

public protocol GridAutoCellProtocol: GridContentProtocol {
    func maxLength(_ maxLength: CGFloat) -> GridAutoCellProtocol
    func minLength(_ minLength: CGFloat) -> GridAutoCellProtocol
}

public class GridAutoCell: GridContentBase {
    
    override func calculateViewWidthForHorizontalGrid(
        boundsSize: CGSize,
        calculatedViewHeight: CGFloat,
        totalExpanded: CGFloat,
        totalConstant: CGFloat
    ) -> CGFloat {
        return min(
            max(
                cell.view.sizeThatFits(.init(width: .zero, height: calculatedViewHeight)).width,
                cell.minLength
            ),
            cell.maxLength - cell.margin.left - cell.margin.right
        )
    }
    
    override func calculateViewHeightForVerticalGrid(
        boundsSize: CGSize,
        calculatedViewWidth: CGFloat,
        totalExpanded: CGFloat,
        totalConstant: CGFloat
    ) -> CGFloat {
        return min(
            max(
                cell.view.sizeThatFits(.init(width: calculatedViewWidth, height: .zero)).height,
                cell.minLength
            ),
            cell.maxLength - cell.margin.top - cell.margin.bottom
        )
    }
    
    override func estimatedCellHeight(
        verticalAlignment: GridVerticalAlignment
    ) -> CGFloat {
        var result: CGFloat
        
        switch verticalAlignment {
            
        case .constantCenter(height: let height):
            result = height
        case .constantTop(height: let height):
            result = height
        case .constantBottom(height: let height):
            result = height
        default:
            result = .zero
        }
        
        if result >= cell.minLength && result <= cell.maxLength {
            return cell.maxLength
        } else if result < cell.minLength {
            return cell.minLength
        } else {
            return cell.maxLength
        }
    }
    
    override func estimatedCellWidth(
        horizontalAlignment: GridHorizontalAlignment
    ) -> CGFloat {
        var result: CGFloat
        
        switch horizontalAlignment {

        case .constantCenter(width: let width):
            result = width
        case .constantLeft(width: let width):
            result = width
        case .constantRight(width: let width):
            result = width
        default:
            result = .zero
        }
        
        if result >= cell.minLength && result <= cell.maxLength {
            return cell.maxLength
        } else if result < cell.minLength {
            return cell.minLength
        } else {
            return cell.maxLength
        }
    }
    
    override func finalCellSize(
        viewSize: CGSize,
        boundsSize: CGSize,
        orientation: GridOrientation
    ) -> CGSize {
        
        let margin = cell.margin
        
        if orientation == .vertical {
            return .init(
                width: boundsSize.width,
                height: viewSize.height + margin.top + margin.bottom
            )
        } else {
            return .init(
                width: viewSize.width + margin.left + margin.right,
                height: boundsSize.height
            )
        }
    }
    
    override func calculateHorizontalSpacing(cellWidth: CGFloat, viewWidth: CGFloat) {
        cell.spacing.right = cell.margin.right
    }
    
    override func calculateVerticalSpacing(cellHeight: CGFloat, viewHeight: CGFloat) {
        cell.spacing.bottom = cell.margin.bottom
    }
}

extension GridAutoCell: GridAutoCellProtocol {
    public func maxLength(_ maxLength: CGFloat) -> any GridAutoCellProtocol {
        cell.maxLength = maxLength
        return self
    }
    
    public func minLength(_ minLength: CGFloat) -> any GridAutoCellProtocol {
        cell.minLength = minLength
        return self
    }
}
