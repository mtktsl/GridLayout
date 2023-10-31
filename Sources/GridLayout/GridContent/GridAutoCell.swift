//
//  GridAutoCell.swift
//  
//
//  Created by Metin Tarık Kiki on 23.10.2023.
//

import UIKit

public class GridAutoCell: GridContentBase {
    
    public func maxLength(_ maxLength: CGFloat) -> GridAutoCell {
        cell.maxLength = maxLength
        return self
    }
    
    public func minLength(_ minLength: CGFloat) -> GridAutoCell {
        cell.minLength = minLength
        return self
    }
    
    override public func calculateViewWidthForHorizontalGrid(
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
    
    override public func calculateViewHeightForVerticalGrid(
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
        let result: CGFloat = switch verticalAlignment {
            
        case .constantCenter(height: let height):
            height
        case .constantTop(height: let height):
            height
        case .constantBottom(height: let height):
            height
        default:
            .zero
        }
        
        return if result >= cell.minLength && result <= cell.maxLength {
            cell.maxLength
        } else if result < cell.minLength {
            cell.minLength
        } else {
            cell.maxLength
        }
    }
    
    override func estimatedCellWidth(
        horizontalAlignment: GridHorizontalAlignment
    ) -> CGFloat {
        let result: CGFloat = switch horizontalAlignment {

        case .constantCenter(width: let width):
            width
        case .constantLeft(width: let width):
            width
        case .constantRight(width: let width):
            width
        default:
            .zero
        }
        
        return if result >= cell.minLength && result <= cell.maxLength {
            cell.maxLength
        } else if result < cell.minLength {
            cell.minLength
        } else {
            cell.maxLength
        }
    }
    
    override public func finalCellSize(
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
