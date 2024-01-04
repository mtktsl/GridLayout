//
//  File.swift
//  
//
//  Created by Metin Tarık Kiki on 2.11.2023.
//

import UIKit

extension Grid {
    
    fileprivate func findContentIndex(of subview: UIView) -> Int? {
        for (i, content) in contents.enumerated() {
            if content.cell.view === subview {
                return i
            }
        }
        return nil
    }
    
    fileprivate func searchSubViewsBySearchingSubgrids(
        _ targetSubview: UIView
    ) -> (subgrid: Grid, index: Int, content: GridContentBase)? {
        
        for (index, content) in contents.enumerated() {
            if content.cell.view === targetSubview {
                return (self, index, content)
            } else if let subgrid = content.cell.view as? Grid,
                      let result = subgrid.searchSubViewsBySearchingSubgrids(targetSubview) {
                return result
            }
        }
        return nil
    }
    
    fileprivate func swapArrangementBetweenSubgrids(
        _ first: (subgrid: Grid, index: Int, content: GridContentBase),
        _ second: (subgrid: Grid, index: Int, content: GridContentBase)
    ) {
        first.subgrid.removeSubcontent(
            subviewToBeRemoved: first.content.cell.view,
            at: first.index
        )
        second.subgrid.removeSubcontent(
            subviewToBeRemoved: second.content.cell.view,
            at: second.index
        )
        
        second.subgrid.addGridContent(at: second.index) {
            first.content
        }
        first.subgrid.addGridContent(at: first.index) {
            second.content
        }
    }
    
    public func swapArrangement(of subview: UIView, with targetView: UIView) {
        
        guard let first = searchSubViewsBySearchingSubgrids(subview),
              let second = searchSubViewsBySearchingSubgrids(targetView)
        else { fatalError("In Grid.swapArrangement: Views provided as parameters has to be subviews of the grid.") }
        
        if first.subgrid === second.subgrid {
            first.subgrid.contents.swapAt(first.index, second.index)
        } else {
            swapArrangementBetweenSubgrids(first, second)
        }
        
        setNeedsLayout()
    }
    
    public func setContentAlignment(
        for subview: UIView,
        alignmentClosure: @escaping (_ view: UIView) -> GridContentProtocol
    ) {
        if let found = searchSubViewsBySearchingSubgrids(subview) {
            let content = alignmentClosure(subview).getInstance()
            if content.cell.view !== subview {
                fatalError("In Grid.setContentAlignment: The UIView object that is returned from the alignmentClosure cannot be a different object than the function view parameter.")
            }
            
            found.subgrid.contents[found.index].deactivateAlignmentConstraints()
            found.subgrid.contents[found.index] = content
            found.subgrid.calculateTotalConstants()
            setNeedsLayout()
        } else {
            fatalError("In Grid.setContentAlignment: Provided view parameter is not a subview of the grid.")
        }
    }
    
    public func addGridContent(at targetIndex: Int = .min, @GridBuilder components: () -> [GridContentBase] ) {
        let newContent = components()
        
        if targetIndex >= 0 && targetIndex < contents.count {
            contents.insert(contentsOf: newContent, at: targetIndex)
        } else {
            contents.append(contentsOf: newContent)
        }
        
        for content in newContent {
            content.cell.view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(content.cell.view)
        }
        
        setNeedsLayout()
    }
    
    fileprivate func removeSubcontent(subviewToBeRemoved: UIView, at index: Int) {
        let removedContent = contents.remove(at: index)
        removedContent.deactivateAlignmentConstraints()
        subviewToBeRemoved.removeFromSuperview()
        setNeedsLayout()
    }
    
    public func removeSubcontent(subviewToBeRemoved: UIView) {
        if let found = searchSubViewsBySearchingSubgrids(subviewToBeRemoved) {
            found.subgrid.removeSubcontent(
                subviewToBeRemoved: subviewToBeRemoved,
                at: found.index
            )
        }
    }
}
