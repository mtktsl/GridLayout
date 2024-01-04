//
//  GridExpandedCell.swift
//  
//
//  Created by Metin Tarık Kiki on 23.10.2023.
//

import UIKit

public class GridExpandedCell: GridContentBase {
    
    private func calculateFittingViewWidthForHorizontalGrid(
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
    
    override func calculateViewWidthForHorizontalGrid(
        forFitting: Bool = false,
        boundsSize: CGSize,
        calculatedViewHeight: CGFloat,
        totalExpanded: CGFloat,
        totalConstant: CGFloat
    ) -> CGFloat {
        
        if forFitting {
            return calculateFittingViewWidthForHorizontalGrid(
                boundsSize: boundsSize,
                calculatedViewHeight: calculatedViewHeight,
                totalExpanded: totalExpanded,
                totalConstant: totalConstant
            )
        }
        
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
    
    private func calculateFittingViewHeightForVerticalGrid(
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
    
    override func calculateViewHeightForVerticalGrid(
        forFitting: Bool = false,
        boundsSize: CGSize,
        calculatedViewWidth: CGFloat,
        totalExpanded: CGFloat,
        totalConstant: CGFloat
    ) -> CGFloat {
        
        if forFitting {
            return calculateFittingViewHeightForVerticalGrid(
                boundsSize: boundsSize,
                calculatedViewWidth: calculatedViewWidth,
                totalExpanded: totalExpanded,
                totalConstant: totalConstant
            )
        }
        
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
    
    private func estimatedFittingCellWidth(
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
    
    override func estimatedCellWidth(
        forFitting: Bool = false,
        horizontalAlignment: GridHorizontalAlignment
    ) -> CGFloat {
        return forFitting
        ? estimatedFittingCellWidth(horizontalAlignment: horizontalAlignment)
        : cell.value * expandMultiplierForWidth(sizingInfo: lastSizingInfo)
    }
    
    private func estimatedFittingCellHeight(verticalAlignment: GridVerticalAlignment) -> CGFloat {
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
    
    override func estimatedCellHeight(
        forFitting: Bool = false,
        verticalAlignment: GridVerticalAlignment
    ) -> CGFloat {
        return forFitting
        ? estimatedFittingCellHeight(verticalAlignment: verticalAlignment)
        : cell.value * expandMultiplierForHeight(sizingInfo: lastSizingInfo)
    }
    
    override func estimatedViewWidth(
        forFitting: Bool = false,
        horizontalAlignment: GridHorizontalAlignment
    ) -> CGFloat {
        
        if forFitting {
            return super.estimatedViewWidth(horizontalAlignment: horizontalAlignment)
        }
        
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
        
        if forFitting {
            return super.estimatedViewHeight(verticalAlignment: verticalAlignment)
        }
        
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
    
    private func finalFittingCellSize(
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
    
    override func finalCellSize(
        forFitting: Bool = false,
        viewSize: CGSize,
        boundsSize: CGSize,
        orientation: GridOrientation
    ) -> CGSize {
        
        if forFitting {
            return finalFittingCellSize(
                viewSize: viewSize,
                boundsSize: boundsSize,
                orientation: orientation
            )
        }
        
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
