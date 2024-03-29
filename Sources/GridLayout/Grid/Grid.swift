//
//  Grid.swift
//  GridPanel
//
//  Created by Metin Tarık Kiki on 25.04.2023.
//

import UIKit

public class Grid: UIView {
    
    private var totalGridConstants: CGFloat = 0
    private var totalGridExpanded: CGFloat = 0
    
    public var orientation: GridOrientation = .vertical {
        didSet {
            if oldValue != orientation {
                setNeedsGridLayout()
            }
        }
    }
    
    internal var contents = [GridContentBase]()
    
    internal var needsGridLayout = true
    
    private var boundsCache: CGSize = .zero
    private var intrinsicContentSizeCache: CGSize = .zero
    
    private var fittingSizeCache: SizeCacheProtocol = SizeCache(capacity: 10)
    
    public override var intrinsicContentSize: CGSize {
        return intrinsicContentSizeCache
    }
    
    public init() {
        super.init(frame: .zero)
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func horizontal(@GridBuilder content: () -> [GridContentBase]) -> Grid {
        return build(cells: content(), gridType: .horizontal)
    }
    
    public static func vertical(@GridBuilder content: () -> [GridContentBase]) -> Grid {
        return build(cells: content(), gridType: .vertical)
    }
    
    private static func build(cells: [GridContentBase], gridType: GridOrientation) -> Grid {
        let grid = Grid()
        grid.contents = cells
        grid.orientation = gridType
        grid.setupSubviews()
        grid.calculateTotalConstants()
        grid.sizeToFit()
        return grid
    }
    
    public static func isViewAutoSizingCompatible(_ view: UIView) -> Bool {
        let sizeMethodOfView = class_getInstanceMethod(
            type(of: view),
            #selector(UIView.sizeThatFits(_:))
        )
        
        let sizeMethod = class_getInstanceMethod(
            UIView.self,
            #selector(UIView.sizeThatFits(_:))
        )
        
        return sizeMethodOfView != sizeMethod
    }
    
    public func setNeedsGridLayout() {
        needsGridLayout = true
        fittingSizeCache.clearCache()
        setSubgridsNeedsLayout()
        setNeedsLayout()
    }
    
    private func setSubgridsNeedsLayout() {
        for content in contents {
            if let subgrid = content.cell.view as? Grid {
                subgrid.setNeedsGridLayout()
            }
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        Self.performWithoutAnimation {
            updateLayout()
        }
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        var result = CGSize.zero
        Self.performWithoutAnimation {
            result = calculateSizeFitting(size)
        }
        return result
    }
    
    public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        var result = CGSize.zero
        Self.performWithoutAnimation {
            result = calculateSizeFitting(targetSize)
        }
        return result
    }
    
    public override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        var result = CGSize.zero
        Self.performWithoutAnimation {
            result = calculateSizeFitting(targetSize)
        }
        return result
    }
    
    
    private func calculateSizeFitting(
        _ targetSize: CGSize
    ) -> CGSize {
        
        if let result = fittingSizeCache.getResult(for: targetSize) {
            return result
        }
        
        let finalContentSizingInfos = calculateContentSizings(
            boundsSize: targetSize
        )
        
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        
        if orientation == .vertical {
            for i in 0 ..< finalContentSizingInfos.endIndex {
                let cellSize = finalContentSizingInfos[i].0
                let cell = contents[i].cell
                
                totalHeight += cellSize.height
                totalWidth = max(
                    contents[i].calculateViewWidthForOrthogonalAlignment(
                        boundsWidth: targetSize.width,
                        autoSizingAvailability: Grid.isViewAutoSizingCompatible(cell.view)
                    ) + cell.margin.left + cell.margin.right,
                    totalWidth
                )
            }
            
        } else {
            for i in 0 ..< finalContentSizingInfos.endIndex {
                let cellSize = finalContentSizingInfos[i].0
                let cell = contents[i].cell
                
                totalWidth += cellSize.width
                totalHeight = max(
                    contents[i].calculateViewHeightForOrthogonalAlignment(
                        boundsHeight: targetSize.height,
                        autoSizingAvailability: Grid.isViewAutoSizingCompatible(cell.view)
                    ) + cell.margin.top + cell.margin.bottom,
                    totalHeight
                )
            }
        }
        
        let calculatedSize = CGSize(width: totalWidth, height: totalHeight)
        
        fittingSizeCache.performCaching(
            targetSize: targetSize,
            result: calculatedSize
        )
        
        return calculatedSize
    }
    
    private func updateLayout() {
        
        if boundsCache == bounds.size && !needsGridLayout {
            return
        }
        
        deactivateAlignmentConstraints()
        calculateTotalConstants()
        
        let contentSizingInfos = calculateContentSizings(
            boundsSize: self.bounds.size
        )
        
        calculateViewSpacings(contentSizingInfos: contentSizingInfos)
        
        setOrthogonalAlignments(contentSizingInfos: contentSizingInfos)
        
        setParallelAlignments(contentSizingInfos: contentSizingInfos)
        
        if orientation == .vertical && (needsGridLayout || boundsCache.width != bounds.width) {
            calculateIntrinsicContentSize(contentSizingInfos)
            invalidateIntrinsicContentSize()
        } else if orientation == .horizontal && (needsGridLayout || boundsCache.height != bounds.height) {
            calculateIntrinsicContentSize(contentSizingInfos)
            invalidateIntrinsicContentSize()
        }
        
        boundsCache = self.bounds.size
        needsGridLayout = false
    }
    
    private func calculateViewSpacings(
        contentSizingInfos: [ ( cellSize: CGSize, viewSize: CGSize ) ]
    ) {
        for i in 0 ..< contents.count {
            contents[i].setSpacing(cellSize: contentSizingInfos[i].cellSize, viewSize: contentSizingInfos[i].viewSize)
        }
    }
    
    private func calculateContentSizings(
        boundsSize: CGSize
    ) -> [ (CGSize, CGSize) ] {
        var contentInfos = [ ( CGSize, CGSize ) ]()
        
        for content in contents {
            contentInfos.append(
                content.calculateSizing(
                    boundsSize: boundsSize,
                    totalExpanded: totalGridExpanded,
                    totalConstant: totalGridConstants,
                    gridType: self.orientation
                )
            )
        }
        
        return contentInfos
    }
    
    private func calculateIntrinsicContentSize(
        _ contentSizingInfos: [(cellSize: CGSize, viewSize: CGSize)]
    ) {
        var finalWidth = CGFloat.zero
        var finalHeight = CGFloat.zero
        
        for info in contentSizingInfos {
            if orientation == .vertical {
                finalWidth = max(finalWidth, info.cellSize.width)
                finalHeight += info.cellSize.height
            } else {
                finalHeight = max(finalHeight, info.cellSize.height)
                finalWidth += info.cellSize.width
            }
        }
        
        intrinsicContentSizeCache.width = finalWidth
        intrinsicContentSizeCache.height = finalHeight
    }
    
    private func deactivateAlignmentConstraints() {
        for content in contents {
            content.deactivateAlignmentConstraints()
        }
    }
    
    private func setupSubviews() {
        for content in contents {
            content.cell.view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(content.cell.view)
        }
    }
    
    internal func calculateTotalConstants() {
        
        totalGridExpanded = 0
        totalGridConstants = 0
        
        for content in contents {
            switch content.cell.gridLength {
            case .expanded:
                totalGridExpanded += content.cell.value
            case .constant:
                totalGridConstants += content.cell.value
            default:
                continue
            }
        }
        
        calculateTotalAuto()
    }
    
    internal func calculateTotalAuto() {
        for content in contents {
            if content.cell.gridLength == .auto {
                let area = content.calculateSizing(
                    boundsSize: self.bounds.size,
                    totalExpanded: totalGridExpanded,
                    totalConstant: totalGridConstants,
                    gridType: self.orientation
                ).cellSize
                
                totalGridConstants += orientation == .horizontal
                ? area.width
                : area.height
            }
        }
    }
    
    private func setOrthogonalAlignments(
        contentSizingInfos: [ ( cellSize: CGSize, viewSize: CGSize ) ]
    ) {
        for i in 0 ..< contents.count {
            setOrthogonalAlignment(
                for: contents[i],
                cellSize: contentSizingInfos[i].cellSize,
                viewSize: contentSizingInfos[i].viewSize
            )
        }
    }
    
    private func setOrthogonalAlignment(
        for content: GridContentBase,
        cellSize: CGSize,
        viewSize: CGSize
    ) {
        if orientation == .vertical {
            setOrthogonalHorizontalAlignment(
                content: content,
                cellSize: cellSize,
                viewSize: viewSize
            )
        } else {
            setOrthogonalVerticalAlignment(
                content: content,
                cellSize: cellSize,
                viewSize: viewSize
            )
        }
    }
    
    private func setOrthogonalVerticalAlignment(
        content: GridContentBase,
        cellSize: CGSize,
        viewSize: CGSize
    ) {
        let alignment = content.cell.verticalAlignment
        let view = content.cell.view
        let margin = content.cell.margin
        
        switch alignment {
            
        case .fill:
            content.setConstraints([
                view.topAnchor.constraint(
                    equalTo: self.topAnchor,
                    constant: margin.top
                ),
                view.bottomAnchor.constraint(
                    equalTo: self.bottomAnchor,
                    constant: -margin.bottom
                )
            ])
            
        case .constantCenter(height: let height):
            content.setConstraints([
                view.centerYAnchor.constraint(
                    equalTo: self.centerYAnchor,
                    constant: margin.top - margin.bottom
                ),
                view.heightAnchor.constraint(equalToConstant: height)
            ])
            
        case .autoCenter:
            content.setConstraints([
                view.centerYAnchor.constraint(
                    equalTo: self.centerYAnchor,
                    constant: margin.top - margin.bottom
                ),
                view.heightAnchor.constraint(equalToConstant: viewSize.height)
            ])
            
        case .constantTop(height: let height):
            content.setConstraints([
                view.topAnchor.constraint(
                    equalTo: self.topAnchor,
                    constant: margin.top
                ),
                view.heightAnchor.constraint(equalToConstant: height)
            ])
            
        case .autoTop:
            content.setConstraints([
                view.topAnchor.constraint(
                    equalTo: self.topAnchor,
                    constant: margin.top
                ),
                view.heightAnchor.constraint(equalToConstant: viewSize.height)
            ])
            
        case .constantBottom(height: let height):
            content.setConstraints([
                view.bottomAnchor.constraint(
                    equalTo: self.bottomAnchor,
                    constant: -margin.bottom
                ),
                view.heightAnchor.constraint(equalToConstant: height)
            ])
            
        case .autoBottom:
            content.setConstraints([
                view.bottomAnchor.constraint(
                    equalTo: self.bottomAnchor,
                    constant: -margin.bottom
                ),
                view.heightAnchor.constraint(equalToConstant: viewSize.height)
            ])
        }
    }
    
    private func setOrthogonalHorizontalAlignment(
        content: GridContentBase,
        cellSize: CGSize,
        viewSize: CGSize
    ) {
        let alignment = content.cell.horizontalAlignment
        let view = content.cell.view
        let margin = content.cell.margin
        
        switch alignment {

        case .fill:
            content.setConstraints([
                view.leadingAnchor.constraint(
                    equalTo: self.leadingAnchor,
                    constant: margin.left
                ),
                
                view.trailingAnchor.constraint(
                    equalTo: self.trailingAnchor,
                    constant: -margin.right
                )
            ])
            
        case .constantCenter(width: let width):
            content.setConstraints([
                view.centerXAnchor.constraint(
                    equalTo: self.centerXAnchor,
                    constant: margin.left - margin.right
                ),
                view.widthAnchor.constraint(equalToConstant: width)
            ])
            
        case .autoCenter:
            content.setConstraints([
                view.centerXAnchor.constraint(
                    equalTo: self.centerXAnchor,
                    constant: margin.left - margin.right
                ),
                view.widthAnchor.constraint(equalToConstant: viewSize.width)
            ])
        case .constantLeft(width: let width):
            content.setConstraints([
                view.leadingAnchor.constraint(
                    equalTo: self.leadingAnchor,
                    constant: margin.left
                ),
                view.widthAnchor.constraint(equalToConstant: width)
            ])
        case .autoLeft:
            content.setConstraints([
                view.leadingAnchor.constraint(
                    equalTo: self.leadingAnchor,
                    constant: margin.left
                ),
                view.widthAnchor.constraint(equalToConstant: viewSize.width)
            ])
        case .constantRight(width: let width):
            content.setConstraints([
                view.trailingAnchor.constraint(
                    equalTo: self.trailingAnchor,
                    constant: -margin.right
                ),
                view.widthAnchor.constraint(equalToConstant: width)
            ])
        case .autoRight:
            content.setConstraints([
                view.trailingAnchor.constraint(
                    equalTo: self.trailingAnchor,
                    constant: -margin.right
                ),
                view.widthAnchor.constraint(equalToConstant: viewSize.width)
            ])
        }
    }
    
    private func setParallelAlignments(
        contentSizingInfos: [ ( cellSize: CGSize, viewSize: CGSize ) ]
    ) {
        guard let firstContent = contents.first,
              let firstSizingInfo = contentSizingInfos.first
        else { return }
        
        setInitialParallelAlignment(
            initialContent: firstContent,
            cellSize: firstSizingInfo.cellSize,
            viewSize: firstSizingInfo.viewSize
        )
        
        for i in 1 ..< contents.count {
            setParallelAlignment(
                sourceContent: contents[i],
                targetContent: contents[i-1],
                cellSize: contentSizingInfos[i].cellSize,
                viewSize: contentSizingInfos[i].viewSize
            )
        }
    }
    
    private func setInitialParallelAlignment(
        initialContent: GridContentBase,
        cellSize: CGSize,
        viewSize: CGSize
    ) {
        if orientation == .vertical {
            setInitialParallelVerticalAlignment(
                initialContent: initialContent,
                cellHeight: cellSize.height,
                viewHeight: viewSize.height
            )
        } else {
            setInitialParallelHorizontalAlignment(
                initialContent: initialContent,
                cellWidth: cellSize.width,
                viewWidth: viewSize.width
            )
        }
    }
    
    private func setParallelAlignment(
        sourceContent: GridContentBase,
        targetContent: GridContentBase,
        cellSize: CGSize,
        viewSize: CGSize
    ) {
        if orientation == .vertical {
            setParallelVerticalAlignment(
                sourceContent: sourceContent,
                targetContent: targetContent,
                cellSize: cellSize,
                viewSize: viewSize
            )
            
        } else {
            setParallelHorizontalAlignment(
                sourceContent: sourceContent,
                targetContent: targetContent,
                cellSize: cellSize,
                viewSize: viewSize
            )
        }
    }
    
    private func setInitialParallelVerticalAlignment(
        initialContent: GridContentBase,
        cellHeight: CGFloat,
        viewHeight: CGFloat
    ) {
        let view = initialContent.cell.view
        let margin = initialContent.cell.margin
        
        switch initialContent.cell.verticalAlignment {
            
        case .fill:
            initialContent.setConstraints([
                view.topAnchor.constraint(
                    equalTo: self.topAnchor,
                    constant: margin.top
                ),
                view.heightAnchor.constraint(equalToConstant: viewHeight)
            ])
            
        case .constantCenter(height: let height):
            initialContent.setConstraints([
                view.topAnchor.constraint(
                    equalTo: self.topAnchor,
                    constant: margin.top
                    + (cellHeight / 2)
                    - (height / 2)
                    - (margin.bottom)
                ),
                view.heightAnchor.constraint(equalToConstant: height)
            ])
            
        case .autoCenter:
            initialContent.setConstraints([
                view.topAnchor.constraint(
                    equalTo: self.topAnchor,
                    constant: margin.top
                    + (cellHeight / 2)
                    - (viewHeight / 2)
                    - (margin.bottom)
                ),
                view.heightAnchor.constraint(equalToConstant: viewHeight)
            ])
            
        case .constantTop(height: let height):
            initialContent.setConstraints([
                view.topAnchor.constraint(
                    equalTo: self.topAnchor,
                    constant: margin.top
                ),
                view.heightAnchor.constraint(equalToConstant: height)
            ])
            
        case .autoTop:
            initialContent.setConstraints([
                view.topAnchor.constraint(
                    equalTo: self.topAnchor,
                    constant: margin.top
                ),
                view.heightAnchor.constraint(equalToConstant: viewHeight)
            ])
            
        case .constantBottom(height: let height):
            initialContent.setConstraints([
                view.topAnchor.constraint(
                    equalTo: self.topAnchor,
                    constant: margin.top
                    + (cellHeight - height)
                    - margin.bottom
                ),
                view.heightAnchor.constraint(equalToConstant: height)
            ])
            
        case .autoBottom:
            initialContent.setConstraints([
                view.topAnchor.constraint(
                    equalTo: self.topAnchor,
                    constant: margin.top
                    + (cellHeight - viewHeight)
                    - margin.bottom
                ),
                view.heightAnchor.constraint(equalToConstant: viewHeight)
            ])
        }
    }
    
    private func setParallelVerticalAlignment(
        sourceContent: GridContentBase,
        targetContent: GridContentBase,
        cellSize: CGSize,
        viewSize: CGSize
    ) {
        let sourceView = sourceContent.cell.view
        let targetView = targetContent.cell.view
        
        let sourceMargin = sourceContent.cell.margin
        let targetSpacing = targetContent.cell.spacing
        
        switch sourceContent.cell.verticalAlignment {
            
        case .fill:
            sourceContent.setConstraints([
                sourceView.topAnchor.constraint(
                    equalTo: targetView.bottomAnchor,
                    constant: sourceMargin.top + targetSpacing.bottom
                ),
                sourceView.heightAnchor.constraint(equalToConstant: viewSize.height)
            ])
            
        case .constantCenter(height: let height):
            sourceContent.setConstraints([
                sourceView.topAnchor.constraint(
                    equalTo: targetView.bottomAnchor,
                    constant: sourceMargin.top
                    + targetSpacing.bottom
                    + (cellSize.height / 2)
                    - (height / 2)
                    - sourceMargin.bottom
                ),
                sourceView.heightAnchor.constraint(equalToConstant: height)
            ])
            
        case .autoCenter:
            sourceContent.setConstraints([
                sourceView.topAnchor.constraint(
                    equalTo: targetView.bottomAnchor,
                    constant: sourceMargin.top
                    + targetSpacing.bottom
                    + (cellSize.height / 2)
                    - (viewSize.height / 2)
                    - sourceMargin.bottom
                ),
                sourceView.heightAnchor.constraint(equalToConstant: viewSize.height)
            ])
            
        case .constantTop(height: let height):
            sourceContent.setConstraints([
                sourceView.topAnchor.constraint(
                    equalTo: targetView.bottomAnchor,
                    constant: sourceMargin.top + targetSpacing.bottom
                ),
                sourceView.heightAnchor.constraint(equalToConstant: height)
            ])
            
        case .autoTop:
            sourceContent.setConstraints([
                sourceView.topAnchor.constraint(
                    equalTo: targetView.bottomAnchor,
                    constant: sourceMargin.top + targetSpacing.bottom
                ),
                sourceView.heightAnchor.constraint(equalToConstant: viewSize.height)
            ])
            
        case .constantBottom(height: let height):
            sourceContent.setConstraints([
                sourceView.topAnchor.constraint(
                    equalTo: targetView.bottomAnchor,
                    constant: sourceMargin.top 
                    + targetSpacing.bottom
                    + (cellSize.height - height)
                    - sourceMargin.bottom
                ),
                sourceView.heightAnchor.constraint(equalToConstant: height)
            ])
            
        case .autoBottom:
            sourceContent.setConstraints([
                sourceView.topAnchor.constraint(
                    equalTo: targetView.bottomAnchor,
                    constant: sourceMargin.top
                    + targetSpacing.bottom
                    + (cellSize.height - viewSize.height)
                    - sourceMargin.bottom
                ),
                sourceView.heightAnchor.constraint(equalToConstant: viewSize.height)
            ])
        }
    }
    
    private func setInitialParallelHorizontalAlignment(
        initialContent: GridContentBase,
        cellWidth: CGFloat,
        viewWidth: CGFloat
    ) {
        let view = initialContent.cell.view
        let margin = initialContent.cell.margin
        
        switch initialContent.cell.horizontalAlignment {
            
        case .fill:
            initialContent.setConstraints([
                view.leadingAnchor.constraint(
                    equalTo: self.leadingAnchor,
                    constant: margin.left
                ),
                view.widthAnchor.constraint(equalToConstant: viewWidth)
            ])
            
        case .constantCenter(width: let width):
            initialContent.setConstraints([
                view.leadingAnchor.constraint(
                    equalTo: self.leadingAnchor,
                    constant: margin.left
                    + (cellWidth / 2)
                    - (width / 2)
                    - margin.right
                ),
                view.widthAnchor.constraint(equalToConstant: width)
            ])
            
        case .autoCenter:
            initialContent.setConstraints([
                view.leadingAnchor.constraint(
                    equalTo: self.leadingAnchor,
                    constant: margin.left
                    + (cellWidth / 2)
                    - (viewWidth / 2)
                    - margin.right
                ),
                view.widthAnchor.constraint(equalToConstant: viewWidth)
            ])
            
        case .constantLeft(width: let width):
            initialContent.setConstraints([
                view.leadingAnchor.constraint(
                    equalTo: self.leadingAnchor,
                    constant: margin.left
                ),
                view.widthAnchor.constraint(equalToConstant: width)
            ])
            
        case .autoLeft:
            initialContent.setConstraints([
                view.leadingAnchor.constraint(
                    equalTo: self.leadingAnchor,
                    constant: margin.left
                ),
                view.widthAnchor.constraint(equalToConstant: viewWidth)
            ])
            
        case .constantRight(width: let width):
            initialContent.setConstraints([
                view.leadingAnchor.constraint(
                    equalTo: self.leadingAnchor,
                    constant: margin.left
                    + (cellWidth - width)
                    - margin.right
                ),
                view.widthAnchor.constraint(equalToConstant: width)
            ])
            
        case .autoRight:
            initialContent.setConstraints([
                view.leadingAnchor.constraint(
                    equalTo: self.leadingAnchor,
                    constant: margin.left
                    + (cellWidth - viewWidth)
                    - margin.right
                ),
                view.widthAnchor.constraint(equalToConstant: viewWidth)
            ])
        }
    }
    
    private func setParallelHorizontalAlignment(
        sourceContent: GridContentBase,
        targetContent: GridContentBase,
        cellSize: CGSize,
        viewSize: CGSize
    ) {
        let sourceView = sourceContent.cell.view
        let targetView = targetContent.cell.view
        
        let sourceMargin = sourceContent.cell.margin
        let targetSpacing = targetContent.cell.spacing
        
        var alignmentConstraints = [NSLayoutConstraint]()
        
        switch sourceContent.cell.horizontalAlignment {
            
        case .fill:
            alignmentConstraints = [
                sourceView.leadingAnchor.constraint(
                    equalTo: targetView.trailingAnchor,
                    constant: sourceMargin.left + targetSpacing.right
                ),
                sourceView.widthAnchor.constraint(equalToConstant: viewSize.width)
            ]
            
        case .constantCenter(width: let width):
            alignmentConstraints = [
                sourceView.leadingAnchor.constraint(
                    equalTo: targetView.trailingAnchor, 
                    constant: sourceMargin.left
                    + targetSpacing.right
                    + (cellSize.width / 2)
                    - (width / 2)
                    - sourceMargin.left
                ),
                sourceView.widthAnchor.constraint(equalToConstant: width)
            ]
            
        case .autoCenter:
            alignmentConstraints = [
                sourceView.leadingAnchor.constraint(
                    equalTo: targetView.trailingAnchor,
                    constant: sourceMargin.left
                    + targetSpacing.right
                    + (cellSize.width / 2)
                    - (viewSize.width / 2)
                    - sourceMargin.left
                ),
                sourceView.widthAnchor.constraint(equalToConstant: viewSize.width)
            ]
            
        case .constantLeft(width: let width):
            alignmentConstraints = [
                sourceView.leadingAnchor.constraint(
                    equalTo: targetView.trailingAnchor,
                    constant: sourceMargin.left + targetSpacing.right
                ),
                sourceView.widthAnchor.constraint(equalToConstant: width)
            ]
            
        case .autoLeft:
            alignmentConstraints = [
                sourceView.leadingAnchor.constraint(
                    equalTo: targetView.trailingAnchor,
                    constant: sourceMargin.left + targetSpacing.right
                ),
                sourceView.widthAnchor.constraint(equalToConstant: viewSize.width)
            ]
            
        case .constantRight(width: let width):
            alignmentConstraints = [
                sourceView.leadingAnchor.constraint(
                    equalTo: targetView.trailingAnchor,
                    constant: sourceMargin.left
                    + targetSpacing.right
                    + (cellSize.width - width)
                    - sourceMargin.right
                ),
                sourceView.widthAnchor.constraint(equalToConstant: width)
            ]
            
        case .autoRight:
            alignmentConstraints = [
                sourceView.leadingAnchor.constraint(
                    equalTo: targetView.trailingAnchor,
                    constant: sourceMargin.left
                    + targetSpacing.right
                    + (cellSize.width - viewSize.width)
                    - sourceMargin.right
                ),
                sourceView.widthAnchor.constraint(equalToConstant: viewSize.width)
            ]
        }
        
        sourceContent.setConstraints(alignmentConstraints)
    }
}
