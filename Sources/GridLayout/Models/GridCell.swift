//
//  GridCell.swift
//  GridPanel
//
//  Created by Metin Tarık Kiki on 25.04.2023.
//

import UIKit

public class GridCell {
    var value: CGFloat
    let view: UIView
    var constraints = [NSLayoutConstraint]()
    let gridLength: GridLength
    let horizontalAlignment: GridHorizontalAlignment
    let verticalAlignment: GridVerticalAlignment
    var margin: UIEdgeInsets
    
    var spacing: UIEdgeInsets = .zero
    
    init(value: CGFloat, view: UIView, gridLength: GridLength, horizontalAlignment: GridHorizontalAlignment, verticalAlignment: GridVerticalAlignment, margin: UIEdgeInsets) {
        self.value = value
        self.view = view
        self.gridLength = gridLength
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.margin = margin
    }
}
