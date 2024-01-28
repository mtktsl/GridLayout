//
//  GridExpandedCell.swift
//  
//
//  Created by Metin Tarık Kiki on 23.10.2023.
//

import UIKit

public protocol GridExpandedCellProtocol: GridContentProtocol {
    func canCollapse(_ value: Bool) -> GridContentProtocol
}

public class GridExpandedCell: GridContentBase {
    
    var canCollapse: Bool = false
    
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
        boundsSize: CGSize,
        calculatedViewHeight: CGFloat,
        totalExpanded: CGFloat,
        totalConstant: CGFloat
    ) -> CGFloat {
        
        let view = cell.view
        let margin = cell.margin
        
        var result: CGFloat = .zero
        
        switch cell.horizontalAlignment {
            
        case .fill:
            result = cell.value * expandMultiplierForWidth(sizingInfo: lastSizingInfo)
            - margin.left
            - margin.right
        case .constantCenter(width: let width):
            result = width
        case .constantLeft(width: let width):
            result = width
        case .constantRight(width: let width):
            result = width
        default:
            result = min(
                view.sizeThatFits(.init(
                    width: .zero,
                    height: calculatedViewHeight
                )).width,
                cell.value * expandMultiplierForWidth(sizingInfo: lastSizingInfo)
            )
        }
        
        if result <= .zero && !canCollapse {
            return calculateFittingViewWidthForHorizontalGrid(
                boundsSize: boundsSize,
                calculatedViewHeight: calculatedViewHeight,
                totalExpanded: totalExpanded,
                totalConstant: totalConstant
            )
        } else {
            return result
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
        boundsSize: CGSize,
        calculatedViewWidth: CGFloat,
        totalExpanded: CGFloat,
        totalConstant: CGFloat
    ) -> CGFloat {
        
        var result = CGFloat.zero
        
        let view = cell.view
        
        switch cell.verticalAlignment {
            
        case .fill:
            result = cell.value * expandMultiplierForHeight(sizingInfo: lastSizingInfo)
            - cell.margin.top
            - cell.margin.bottom
        case .constantCenter(height: let height):
            result = height
        case .constantTop(height: let height):
            result = height
        case .constantBottom(height: let height):
            result = height
        default:
            result = min(
                view.sizeThatFits(.init(
                    width: calculatedViewWidth,
                    height: .zero)
                ).height,
                cell.value * expandMultiplierForHeight(sizingInfo: lastSizingInfo)
            )
        }
        
        if result <= .zero && !canCollapse {
            return calculateFittingViewHeightForVerticalGrid(
                boundsSize: boundsSize,
                calculatedViewWidth: calculatedViewWidth,
                totalExpanded: totalExpanded,
                totalConstant: totalConstant
            )
        } else {
            return result
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
        horizontalAlignment: GridHorizontalAlignment
    ) -> CGFloat {
        let result = cell.value * expandMultiplierForWidth(sizingInfo: lastSizingInfo)
        return result <= .zero && !canCollapse
        ? estimatedFittingCellWidth(horizontalAlignment: horizontalAlignment)
        : result
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
        verticalAlignment: GridVerticalAlignment
    ) -> CGFloat {
        let result = cell.value * expandMultiplierForHeight(sizingInfo: lastSizingInfo)
        return result <= .zero && !canCollapse
        ? estimatedFittingCellHeight(verticalAlignment: verticalAlignment)
        : result
    }
    
    override func estimatedViewWidth(
        horizontalAlignment: GridHorizontalAlignment
    ) -> CGFloat {
        
        let result: CGFloat
        
        switch horizontalAlignment {
            
        case .constantCenter(width: let width):
            result = width
        case .constantLeft(width: let width):
            result = width
        case .constantRight(width: let width):
            result = width
        default:
            result = cell.value * expandMultiplierForWidth(sizingInfo: lastSizingInfo)
            - cell.margin.left
            - cell.margin.right
        }
        
        if result <= .zero && !canCollapse {
            return super.estimatedViewWidth(horizontalAlignment: horizontalAlignment)
        } else {
            return result
        }
    }
    
    override func estimatedViewHeight(
        verticalAlignment: GridVerticalAlignment
    ) -> CGFloat {
        
        let result: CGFloat
        
        switch verticalAlignment {
            
        case .constantCenter(height: let height):
            result = height
        case .constantTop(height: let height):
            result = height
        case .constantBottom(height: let height):
            result = height
        default:
            result = cell.value * expandMultiplierForHeight(sizingInfo: lastSizingInfo)
            - cell.margin.top
            - cell.margin.bottom
        }
        
        if result <= .zero && !canCollapse {
            return super.estimatedViewHeight(verticalAlignment: verticalAlignment)
        } else {
            return result
        }
    }
    
    override func finalCellSize(
        viewSize: CGSize,
        boundsSize: CGSize,
        orientation: GridOrientation
    ) -> CGSize {
        
        let margin = cell.margin
        
        switch orientation {
            
        case .horizontal:
            var widthResult = cell.value * expandMultiplierForWidth(sizingInfo: lastSizingInfo)
            
            if widthResult <= .zero && !canCollapse {
                widthResult = viewSize.width + margin.left + margin.right
            }
            
            return CGSize(
                width: widthResult,
                height: boundsSize.height
            )
            
        case .vertical:
            var heightResult = cell.value * expandMultiplierForHeight(sizingInfo: lastSizingInfo)
            
            if heightResult <= .zero && !canCollapse {
                heightResult = viewSize.height + margin.top + margin.bottom
            }
            
            return CGSize(
                width: boundsSize.width,
                height: heightResult
            )
        }
    }
}

extension GridExpandedCell: GridExpandedCellProtocol {
    public func canCollapse(_ value: Bool = true) -> GridContentProtocol {
        self.canCollapse = value
        return self
    }
}
