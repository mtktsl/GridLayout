//
//  GridContentBase.swift
//  
//
//  Created by Metin Tarık Kiki on 27.10.2023.
//

import UIKit

public class GridContentBase {
    
    public var cell: GridCell
    
    private var lastCalculatedSizingInfo: SizingInfo?
    
    internal var lastSizingInfo: SizingInfo {
        lastCalculatedSizingInfo
        ?? .init(boundSize: .zero, totaConstant: .zero, totaExpanded: .zero)
    }
    
    init(cell: GridCell) {
        self.cell = cell
    }
    
    private func expandMultiplier(
        boundsLength: CGFloat,
        totalConstant: CGFloat,
        totalExpanded: CGFloat
    ) -> CGFloat {
        boundsLength > 0
        ? (boundsLength - totalConstant) / totalExpanded
        : 0
    }
    
    internal func expandMultiplierForWidth(sizingInfo: SizingInfo) -> CGFloat {
        return expandMultiplier(
            boundsLength: sizingInfo.boundSize.width,
            totalConstant: sizingInfo.totaConstant,
            totalExpanded: sizingInfo.totaExpanded
        )
    }
    
    internal func expandMultiplierForHeight(sizingInfo: SizingInfo) -> CGFloat {
        return expandMultiplier(
            boundsLength: sizingInfo.boundSize.height,
            totalConstant: sizingInfo.totaConstant,
            totalExpanded: sizingInfo.totaExpanded
        )
    }
    
    internal func calculateVerticalSpacing(
        cellHeight: CGFloat,
        viewHeight: CGFloat
    ) {
        let margin = cell.margin
        
        cell.spacing.bottom = switch cell.verticalAlignment {
            
        case .fill:
            margin.bottom
        
        case .constantCenter(height: let height):
            ((cellHeight - height) / 2)
            + margin.bottom
            - margin.top
        
        case .autoCenter:
            ((cellHeight - viewHeight) / 2)
            + margin.bottom
            - margin.top
            
        case .constantTop(height: let height):
            (cellHeight - height)
            + margin.bottom
            - margin.top
            
        case .autoTop:
            (cellHeight - viewHeight)
            + margin.bottom
            - margin.top
            
        case .constantBottom(_):
            margin.bottom - margin.top
            
        case .autoBottom:
            margin.bottom - margin.top
        }
    }
    
    internal func calculateHorizontalSpacing(
        cellWidth: CGFloat,
        viewWidth: CGFloat
    ) {
        let margin = cell.margin
        
        cell.spacing.right = switch cell.horizontalAlignment {
            
        case .fill:
            margin.right
            
        case .constantCenter(width: let width):
            ((cellWidth - width) / 2)
            + margin.right
            - margin.left
            
        case .autoCenter:
            ((cellWidth - viewWidth) / 2)
            + margin.right
            - margin.left
            
        case .constantLeft(width: let width):
            (cellWidth - width)
            + margin.right
            - margin.left
            
        case .autoLeft:
            (cellWidth - viewWidth)
            + margin.right
            - margin.left
            
        case .constantRight(_):
            margin.right - margin.left
            
        case .autoRight:
            margin.right - margin.left
        }
    }
    
    internal func calculateViewWidthForParallelAlignment(
        calculatedWidth: CGFloat,
        autoSizingAvailability: Bool
    ) -> CGFloat {
        return switch cell.horizontalAlignment {
            
        case .constantCenter(width: let width):
            width
        case .constantLeft(width: let width):
            width
        case .constantRight(width: let width):
            width
        case .fill:
            calculatedWidth
        default:
            autoSizingAvailability
            ? calculatedWidth
            : .zero
        }
    }
    
    internal func calculateViewHeightForParallelAlignment(
        calculatedHeight: CGFloat,
        autoSizingAvailability: Bool
    ) -> CGFloat {
        return switch cell.verticalAlignment {
        case .constantCenter(height: let height):
            height
        case .constantTop(height: let height):
            height
        case .constantBottom(height: let height):
            height
        case .fill:
            calculatedHeight
        default:
            autoSizingAvailability
            ? calculatedHeight
            : .zero
        }
    }
    
    internal func estimatedViewWidth(
        horizontalAlignment: GridHorizontalAlignment
    ) -> CGFloat {
        return estimatedCellWidth(horizontalAlignment: horizontalAlignment)
        - cell.margin.left
        - cell.margin.right
    }
    
    internal func estimatedViewHeight(
        verticalAlignment: GridVerticalAlignment
    ) -> CGFloat {
        return estimatedCellHeight(verticalAlignment: verticalAlignment)
        - cell.margin.top
        - cell.margin.bottom
    }
    
    internal func estimatedCellWidth(
        horizontalAlignment: GridHorizontalAlignment
    ) -> CGFloat {
        return .zero
    }
    
    internal func estimatedCellHeight(
        verticalAlignment: GridVerticalAlignment
    ) -> CGFloat {
        return .zero
    }
    
    open func finalCellSize(
        viewSize: CGSize,
        boundsSize: CGSize,
        orientation: GridOrientation
    ) -> CGSize {
        return viewSize
    }
    
    internal func calculateSizingForVerticalGrid(
        boundsSize: CGSize,
        totalExpanded: CGFloat,
        totalConstant: CGFloat,
        autoSizingAvailability: Bool
    ) -> (cellSize: CGSize, viewSize: CGSize) {
        
        let viewWidth = calculateViewWidthForOrthogonalAlignment(
            boundsWidth: boundsSize.width,
            autoSizingAvailability: autoSizingAvailability
        )
        
        let viewHeight = calculateViewHeightForParallelAlignment(
            calculatedHeight: calculateViewHeightForVerticalGrid(
                boundsSize: boundsSize, 
                calculatedViewWidth: viewWidth,
                totalExpanded: totalExpanded,
                totalConstant: totalConstant
            ),
            autoSizingAvailability: autoSizingAvailability
        )
        
        let viewSize = CGSize(width: viewWidth, height: viewHeight)
        
        let cellSize = finalCellSize(
            viewSize: viewSize,
            boundsSize: boundsSize,
            orientation: .vertical
        )
        
        return (cellSize: cellSize, viewSize: viewSize)
    }
    
    internal func calculateSizingForHorizontalGrid(
        boundsSize: CGSize,
        totalExpanded: CGFloat,
        totalConstant: CGFloat,
        autoSizingAvailability: Bool
    ) -> (cellSize: CGSize, viewSize: CGSize) {
        
        let viewHeight = calculateViewHeightForOrthogonalAlignment(
            boundsHeight: boundsSize.height,
            autoSizingAvailability: autoSizingAvailability
        )
        
        let viewWidth = calculateViewWidthForParallelAlignment(
            calculatedWidth: calculateViewWidthForHorizontalGrid(
                boundsSize: boundsSize,
                calculatedViewHeight: viewHeight,
                totalExpanded: totalExpanded,
                totalConstant: totalConstant
            ),
            autoSizingAvailability: autoSizingAvailability
        )
        
        let viewSize = CGSize(width: viewWidth, height: viewHeight)
        
        let cellSize = finalCellSize(
            viewSize: viewSize,
            boundsSize: boundsSize,
            orientation: .horizontal
        )
        
        return (cellSize: cellSize, viewSize: viewSize)
    }
    
    internal func calculateViewWidthForHorizontalGrid(
        boundsSize: CGSize,
        calculatedViewHeight: CGFloat,
        totalExpanded: CGFloat,
        totalConstant: CGFloat
    ) -> CGFloat {
        return .zero
    }
    
    internal func calculateViewHeightForVerticalGrid(
        boundsSize: CGSize,
        calculatedViewWidth: CGFloat,
        totalExpanded: CGFloat,
        totalConstant: CGFloat
    ) -> CGFloat {
        return .zero
    }
}

extension GridContentBase: GridContentProtocol {

    public func calculateSizing(
        boundsSize: CGSize,
        totalExpanded: CGFloat,
        totalConstant: CGFloat,
        gridType: GridOrientation
    ) -> (cellSize: CGSize, viewSize: CGSize) {
        let isAutoSizingCompatible = Grid.isViewAutoSizingCompatible(cell.view)
        
        lastCalculatedSizingInfo = .init(
            boundSize: boundsSize,
            totaConstant: totalConstant,
            totaExpanded: totalExpanded
        )
        
        if gridType == .vertical {
            return calculateSizingForVerticalGrid(
                boundsSize: boundsSize,
                totalExpanded: totalExpanded,
                totalConstant: totalConstant,
                autoSizingAvailability: isAutoSizingCompatible
            )
        } else {
            return calculateSizingForHorizontalGrid(
                boundsSize: boundsSize,
                totalExpanded: totalExpanded,
                totalConstant: totalConstant,
                autoSizingAvailability: isAutoSizingCompatible
            )
        }
    }
    
    public func calculateViewWidthForOrthogonalAlignment(
        boundsWidth: CGFloat,
        autoSizingAvailability: Bool
    ) -> CGFloat {
        
        let margin = cell.margin
        
        return switch cell.horizontalAlignment {
        case .fill:
            boundsWidth > 0
            ? boundsWidth - margin.left - margin.right
            : cell.view.sizeThatFits(.init(
                width: .zero,
                height: estimatedViewHeight(
                    verticalAlignment: cell.verticalAlignment
                )
            )).width
        case .constantCenter(width: let width):
            width
        case .constantLeft(width: let width):
            width
        case .constantRight(width: let width):
            width
            
        default:
            autoSizingAvailability
            ? min(
                cell.view.sizeThatFits(.init(
                    width: .zero,
                    height: estimatedViewHeight(
                        verticalAlignment: cell.verticalAlignment
                    )
                )).width,
                boundsWidth > 0
                ? boundsWidth - margin.left - margin.right
                : .infinity
            )
            : .zero
        }
    }
    
    public func calculateViewHeightForOrthogonalAlignment(
        boundsHeight: CGFloat,
        autoSizingAvailability: Bool
    ) -> CGFloat {
        let margin = cell.margin
        
        return switch cell.verticalAlignment {
            
        case .fill:
            boundsHeight > 0
            ? boundsHeight - margin.top - margin.bottom
            : cell.view.sizeThatFits(.init(
                width: estimatedViewWidth(
                    horizontalAlignment: cell.horizontalAlignment
                ),
                height: .zero
            )).height
        case .constantCenter(height: let height):
            height
        case .constantTop(height: let height):
            height
        case .constantBottom(height: let height):
            height
        default:
            autoSizingAvailability
            ? min(
                cell.view.sizeThatFits(.init(
                    width: estimatedViewWidth(
                        horizontalAlignment: cell.horizontalAlignment
                    ),
                    height: .zero
                )).height,
                boundsHeight > 0
                ? boundsHeight - margin.bottom - margin.top
                : .infinity
            )
            : .zero
        }
    }
    
    public func setSpacing(cellSize: CGSize, viewSize: CGSize) {
        calculateVerticalSpacing(cellHeight: cellSize.height, viewHeight: viewSize.height)
        calculateHorizontalSpacing(cellWidth: cellSize.width, viewWidth: viewSize.width)
    }
}
