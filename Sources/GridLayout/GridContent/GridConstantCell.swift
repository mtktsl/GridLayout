//
//  GridConstantCell.swift
//  
//
//  Created by Metin Tarık Kiki on 23.10.2023.
//

import UIKit

public class GridConstantCell: GridContentBase {
    
    override public func calculateViewWidthForHorizontalGrid(
        boundsSize: CGSize,
        calculatedViewHeight: CGFloat,
        totalExpanded: CGFloat,
        totalConstant: CGFloat
    ) -> CGFloat {
        
        let view = cell.view
        let margin = cell.margin
        
        return switch cell.horizontalAlignment {
            
        case .fill:
            cell.value - margin.left - margin.right
        case .constantCenter(width: let width):
            width
        case .constantLeft(width: let width):
            width
        case .constantRight(width: let width):
            width
        default:
            min(
                view.sizeThatFits(.init(
                    width: .zero,
                    height: calculatedViewHeight
                )).width,
                cell.value
            )
        }
    }
    
    override public func calculateViewHeightForVerticalGrid(
        boundsSize: CGSize,
        calculatedViewWidth: CGFloat,
        totalExpanded: CGFloat,
        totalConstant: CGFloat
    ) -> CGFloat {
        let view = cell.view
        
        return switch cell.verticalAlignment {
            
        case .fill:
            cell.value - cell.margin.top - cell.margin.bottom
        case .constantCenter(height: let height):
            height
        case .constantTop(height: let height):
            height
        case .constantBottom(height: let height):
            height
        default:
            min(
                view.sizeThatFits(.init(
                    width: calculatedViewWidth,
                    height: .zero)
                ).height,
                cell.value
            )
        }
    }
    
    override func estimatedCellWidth(horizontalAlignment: GridHorizontalAlignment) -> CGFloat {
        return cell.value
    }
    
    override func estimatedCellHeight(verticalAlignment: GridVerticalAlignment) -> CGFloat {
        return cell.value
    }
    
    override func estimatedViewWidth(horizontalAlignment: GridHorizontalAlignment) -> CGFloat {
        return switch horizontalAlignment {
            
        case .constantCenter(width: let width):
            width
        case .constantLeft(width: let width):
            width
        case .constantRight(width: let width):
            width
        default:
            cell.value - cell.margin.left - cell.margin.right
        }
    }
    
    override func estimatedViewHeight(verticalAlignment: GridVerticalAlignment) -> CGFloat {
        switch verticalAlignment {
            
        case .constantCenter(height: let height):
            height
        case .constantTop(height: let height):
            height
        case .constantBottom(height: let height):
            height
        default:
            cell.value - cell.margin.top - cell.margin.bottom
        }
    }
    
    override public func finalCellSize(
        viewSize: CGSize,
        boundsSize: CGSize,
        orientation: GridOrientation
    ) -> CGSize {
        return switch orientation {
            
        case .horizontal:
            CGSize(width: cell.value, height: boundsSize.height)
        case .vertical:
            CGSize(width: boundsSize.width, height: cell.value)
        }
    }
}
