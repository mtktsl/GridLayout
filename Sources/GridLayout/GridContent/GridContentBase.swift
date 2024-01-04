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
        
        switch cell.verticalAlignment {
            
        case .fill:
            cell.spacing.bottom = margin.bottom
        
        case .constantCenter(height: let height):
            cell.spacing.bottom = ((cellHeight - height) / 2)
            + margin.bottom
            - margin.top
        
        case .autoCenter:
            cell.spacing.bottom = ((cellHeight - viewHeight) / 2)
            + margin.bottom
            - margin.top
            
        case .constantTop(height: let height):
            cell.spacing.bottom = (cellHeight - height)
            + margin.bottom
            - margin.top
            
        case .autoTop:
            cell.spacing.bottom = (cellHeight - viewHeight)
            + margin.bottom
            - margin.top
            
        case .constantBottom(_):
            cell.spacing.bottom = margin.bottom - margin.top
            
        case .autoBottom:
            cell.spacing.bottom = margin.bottom - margin.top
        }
    }
    
    internal func calculateHorizontalSpacing(
        cellWidth: CGFloat,
        viewWidth: CGFloat
    ) {
        let margin = cell.margin
        
        switch cell.horizontalAlignment {
            
        case .fill:
            cell.spacing.right = margin.right
            
        case .constantCenter(width: let width):
            cell.spacing.right = ((cellWidth - width) / 2)
            + margin.right
            - margin.left
            
        case .autoCenter:
            cell.spacing.right = ((cellWidth - viewWidth) / 2)
            + margin.right
            - margin.left
            
        case .constantLeft(width: let width):
            cell.spacing.right = (cellWidth - width)
            + margin.right
            - margin.left
            
        case .autoLeft:
            cell.spacing.right = (cellWidth - viewWidth)
            + margin.right
            - margin.left
            
        case .constantRight(_):
            cell.spacing.right = margin.right - margin.left
            
        case .autoRight:
            cell.spacing.right = margin.right - margin.left
        }
    }
    
    internal func calculateViewWidthForParallelAlignment(
        calculatedWidth: CGFloat,
        autoSizingAvailability: Bool
    ) -> CGFloat {
        switch cell.horizontalAlignment {
            
        case .constantCenter(width: let width):
            return width
        case .constantLeft(width: let width):
            return width
        case .constantRight(width: let width):
            return width
        case .fill:
            return calculatedWidth
        default:
            return autoSizingAvailability
            ? calculatedWidth
            : .zero
        }
    }
    
    internal func calculateViewHeightForParallelAlignment(
        calculatedHeight: CGFloat,
        autoSizingAvailability: Bool
    ) -> CGFloat {
        switch cell.verticalAlignment {
        case .constantCenter(height: let height):
            return height
        case .constantTop(height: let height):
            return height
        case .constantBottom(height: let height):
            return height
        case .fill:
            return calculatedHeight
        default:
            return autoSizingAvailability
            ? calculatedHeight
            : .zero
        }
    }
    
    internal func estimatedViewWidth(
        forFitting: Bool = false,
        horizontalAlignment: GridHorizontalAlignment
    ) -> CGFloat {
        return estimatedCellWidth(
            forFitting: forFitting,
            horizontalAlignment: horizontalAlignment
        )
        - cell.margin.left
        - cell.margin.right
    }
    
    internal func estimatedViewHeight(
        forFitting: Bool = false,
        verticalAlignment: GridVerticalAlignment
    ) -> CGFloat {
        return estimatedCellHeight(
            forFitting: forFitting,
            verticalAlignment: verticalAlignment
        )
        - cell.margin.top
        - cell.margin.bottom
    }
    
    internal func estimatedCellWidth(
        forFitting: Bool = false,
        horizontalAlignment: GridHorizontalAlignment
    ) -> CGFloat {
        return .zero
    }
    
    internal func estimatedCellHeight(
        forFitting: Bool = false,
        verticalAlignment: GridVerticalAlignment
    ) -> CGFloat {
        return .zero
    }
    
    internal func finalCellSize(
        forFitting: Bool = false,
        viewSize: CGSize,
        boundsSize: CGSize,
        orientation: GridOrientation
    ) -> CGSize {
        return viewSize
    }
    
    internal func calculateSizingForVerticalGrid(
        forFitting: Bool = false,
        boundsSize: CGSize,
        totalExpanded: CGFloat,
        totalConstant: CGFloat,
        autoSizingAvailability: Bool
    ) -> (cellSize: CGSize, viewSize: CGSize) {
        
        let viewWidth = calculateViewWidthForOrthogonalAlignment(
            forFitting: forFitting,
            boundsWidth: boundsSize.width,
            autoSizingAvailability: autoSizingAvailability
        )
        
        let viewHeight = calculateViewHeightForParallelAlignment(
            calculatedHeight: calculateViewHeightForVerticalGrid(
                forFitting: forFitting,
                boundsSize: boundsSize,
                calculatedViewWidth: viewWidth,
                totalExpanded: totalExpanded,
                totalConstant: totalConstant
            ),
            autoSizingAvailability: autoSizingAvailability
        )
        
        let viewSize = CGSize(
            width: max(viewWidth, .zero),
            height: max(viewHeight, .zero)
        )
        
        let cellSize = finalCellSize(
            forFitting: forFitting,
            viewSize: viewSize,
            boundsSize: boundsSize,
            orientation: .vertical
        )
        
        return (cellSize: cellSize, viewSize: viewSize)
    }
    
    internal func calculateSizingForHorizontalGrid(
        forFitting: Bool = false,
        boundsSize: CGSize,
        totalExpanded: CGFloat,
        totalConstant: CGFloat,
        autoSizingAvailability: Bool
    ) -> (cellSize: CGSize, viewSize: CGSize) {
        
        let viewHeight = calculateViewHeightForOrthogonalAlignment(
            forFitting: forFitting,
            boundsHeight: boundsSize.height,
            autoSizingAvailability: autoSizingAvailability
        )
        
        let viewWidth = calculateViewWidthForParallelAlignment(
            calculatedWidth: calculateViewWidthForHorizontalGrid(
                forFitting: forFitting,
                boundsSize: boundsSize,
                calculatedViewHeight: viewHeight,
                totalExpanded: totalExpanded,
                totalConstant: totalConstant
            ),
            autoSizingAvailability: autoSizingAvailability
        )
        
        let viewSize = CGSize(
            width: max(viewWidth, .zero),
            height: max(viewHeight, .zero)
        )
        
        let cellSize = finalCellSize(
            forFitting: forFitting,
            viewSize: viewSize,
            boundsSize: boundsSize,
            orientation: .horizontal
        )
        
        return (cellSize: cellSize, viewSize: viewSize)
    }
    
    internal func calculateViewWidthForHorizontalGrid(
        forFitting: Bool = false,
        boundsSize: CGSize,
        calculatedViewHeight: CGFloat,
        totalExpanded: CGFloat,
        totalConstant: CGFloat
    ) -> CGFloat {
        return .zero
    }
    
    internal func calculateViewHeightForVerticalGrid(
        forFitting: Bool = false,
        boundsSize: CGSize,
        calculatedViewWidth: CGFloat,
        totalExpanded: CGFloat,
        totalConstant: CGFloat
    ) -> CGFloat {
        return .zero
    }
    
    
    internal func calculateSizing(
        forFitting: Bool = false,
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
                forFitting: forFitting,
                boundsSize: boundsSize,
                totalExpanded: totalExpanded,
                totalConstant: totalConstant,
                autoSizingAvailability: isAutoSizingCompatible
            )
        } else {
            return calculateSizingForHorizontalGrid(
                forFitting: forFitting,
                boundsSize: boundsSize,
                totalExpanded: totalExpanded,
                totalConstant: totalConstant,
                autoSizingAvailability: isAutoSizingCompatible
            )
        }
    }
    
    internal func calculateViewWidthForOrthogonalAlignment(
        forFitting: Bool = false,
        boundsWidth: CGFloat,
        autoSizingAvailability: Bool
    ) -> CGFloat {
        
        let margin = cell.margin
        
        switch cell.horizontalAlignment {
        case .fill:
            return boundsWidth > 0
            ? boundsWidth - margin.left - margin.right
            : autoSizingAvailability
            ? cell.view.sizeThatFits(.init(
                width: .zero,
                height: estimatedViewHeight(
                    forFitting: forFitting,
                    verticalAlignment: cell.verticalAlignment
                )
            )).width
            : .zero
        case .constantCenter(width: let width):
            return width
        case .constantLeft(width: let width):
            return width
        case .constantRight(width: let width):
            return width
            
        default:
            return autoSizingAvailability
            ? min(
                cell.view.sizeThatFits(.init(
                    width: .zero,
                    height: estimatedViewHeight(
                        forFitting: forFitting,
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
    
    var count = 0
    
    internal func calculateViewHeightForOrthogonalAlignment(
        forFitting: Bool = false,
        boundsHeight: CGFloat,
        autoSizingAvailability: Bool
    ) -> CGFloat {
        let margin = cell.margin
        
        switch cell.verticalAlignment {
            
        case .fill:
            return boundsHeight > 0
            ? boundsHeight - margin.top - margin.bottom
            : autoSizingAvailability
            ? cell.view.sizeThatFits(.init(
                width: estimatedViewWidth(
                    forFitting: forFitting,
                    horizontalAlignment: cell.horizontalAlignment
                ),
                height: .zero
            )).height
            : .zero
            
        case .constantCenter(height: let height):
            return height
        case .constantTop(height: let height):
            return height
        case .constantBottom(height: let height):
            return height
        default:
            return autoSizingAvailability
            ? min(
                cell.view.sizeThatFits(.init(
                    width: estimatedViewWidth(
                        forFitting: forFitting,
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
    
    internal func setSpacing(cellSize: CGSize, viewSize: CGSize) {
        calculateVerticalSpacing(cellHeight: cellSize.height, viewHeight: viewSize.height)
        calculateHorizontalSpacing(cellWidth: cellSize.width, viewWidth: viewSize.width)
    }
    
    internal func deactivateAlignmentConstraints() {
        NSLayoutConstraint.deactivate(cell.constraints)
    }
    
    internal func setConstraints(_ constraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.activate(constraints)
        cell.constraints.append(contentsOf: constraints)
    }
}

extension GridContentBase: GridContentProtocol {
    public static func == (lhs: GridContentBase, rhs: GridContentBase) -> Bool {
        return true
    }
    
    
    public func horizontalAlignment(_ alignment: GridHorizontalAlignment) -> any GridContentProtocol {
        cell.horizontalAlignment = alignment
        return self
    }
    
    public func verticalAlignment(_ alignment: GridVerticalAlignment) -> any GridContentProtocol {
        cell.verticalAlignment = alignment
        return self
    }
    
    public func margin(_ margin: UIEdgeInsets) -> any GridContentProtocol {
        cell.margin = margin
        return self
    }
    
    public func getInstance() -> GridContentBase {
        return self
    }
}
