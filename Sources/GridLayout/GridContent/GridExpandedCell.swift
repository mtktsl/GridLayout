//
//  GridExpandedCell.swift
//  
//
//  Created by Metin Tarık Kiki on 23.10.2023.
//

import UIKit

public class GridExpandedCell: GridContentBase {
    
    override func calculateViewWidthForHorizontalGrid(
        forFitting: Bool = false,
        boundsSize: CGSize,
        calculatedViewHeight: CGFloat,
        totalExpanded: CGFloat,
        totalConstant: CGFloat
    ) -> CGFloat {
        
        let view = cell.view
        let margin = cell.margin
        
        switch cell.horizontalAlignment {
            
        case .fill:
            return cell.value * expandMultiplierForWidth(sizingInfo: lastSizingInfo)
            - margin.left
            - margin.right
        case .constantCenter(width: let width):
            return width
        case .constantLeft(width: let width):
            return width
        case .constantRight(width: let width):
            return width
        default:
            return min(
                view.sizeThatFits(.init(
                    width: .zero,
                    height: calculatedViewHeight
                )).width,
                cell.value * expandMultiplierForWidth(sizingInfo: lastSizingInfo)
            )
        }
    }
    
    override func calculateViewHeightForVerticalGrid(
        forFitting: Bool = false,
        boundsSize: CGSize,
        calculatedViewWidth: CGFloat,
        totalExpanded: CGFloat,
        totalConstant: CGFloat
    ) -> CGFloat {
        
        let view = cell.view
        
        switch cell.verticalAlignment {
            
        case .fill:
            return cell.value * expandMultiplierForHeight(sizingInfo: lastSizingInfo)
            - cell.margin.top
            - cell.margin.bottom
        case .constantCenter(height: let height):
            return height
        case .constantTop(height: let height):
            return height
        case .constantBottom(height: let height):
            return height
        default:
            return min(
                view.sizeThatFits(.init(
                    width: calculatedViewWidth,
                    height: .zero)
                ).height,
                cell.value * expandMultiplierForHeight(sizingInfo: lastSizingInfo)
            )
        }
    }
    
    override func estimatedCellWidth(
        forFitting: Bool = false,
        horizontalAlignment: GridHorizontalAlignment
    ) -> CGFloat {
        return cell.value * expandMultiplierForWidth(sizingInfo: lastSizingInfo)
    }
    
    override func estimatedCellHeight(
        forFitting: Bool = false,
        verticalAlignment: GridVerticalAlignment
    ) -> CGFloat {
        return cell.value * expandMultiplierForHeight(sizingInfo: lastSizingInfo)
    }
    
    override func estimatedViewWidth(
        forFitting: Bool = false,
        horizontalAlignment: GridHorizontalAlignment
    ) -> CGFloat {
        
        switch horizontalAlignment {
            
        case .constantCenter(width: let width):
            return width
        case .constantLeft(width: let width):
            return width
        case .constantRight(width: let width):
            return width
        default:
            return cell.value * expandMultiplierForWidth(sizingInfo: lastSizingInfo)
            - cell.margin.left
            - cell.margin.right
        }
    }
    
    override func estimatedViewHeight(
        forFitting: Bool = false,
        verticalAlignment: GridVerticalAlignment
    ) -> CGFloat {
        
        switch verticalAlignment {
            
        case .constantCenter(height: let height):
            return height
        case .constantTop(height: let height):
            return height
        case .constantBottom(height: let height):
            return height
        default:
            return cell.value * expandMultiplierForHeight(sizingInfo: lastSizingInfo)
            - cell.margin.top
            - cell.margin.bottom
        }
    }
    
    override func finalCellSize(
        forFitting: Bool = false,
        viewSize: CGSize,
        boundsSize: CGSize,
        orientation: GridOrientation
    ) -> CGSize {
        
        switch orientation {
            
        case .horizontal:
            return CGSize(
                width: cell.value * expandMultiplierForWidth(sizingInfo: lastSizingInfo),
                height: boundsSize.height
            )
        case .vertical:
            return CGSize(
                width: boundsSize.width,
                height: cell.value * expandMultiplierForHeight(sizingInfo: lastSizingInfo)
            )
        }
    }
}
