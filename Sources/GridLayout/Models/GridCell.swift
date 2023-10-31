//
//  GridCell.swift
//  GridPanel
//
//  Created by Metin Tarık Kiki on 25.04.2023.
//

import UIKit

public class GridCell {
    
    var constraints = [NSLayoutConstraint]()
    var gridLength: GridLength
    
    var value: CGFloat
    var view: UIView
    var horizontalAlignment: GridHorizontalAlignment
    var verticalAlignment: GridVerticalAlignment
    
    var maxLength: CGFloat {
        didSet {
            if maxLength < minLength {
                print("GridCell: Attempted to set maxLength as less than minLength in GridCell. \nValues are equalized instead.")
                maxLength = minLength
            }
        }
    }
    var minLength: CGFloat {
        didSet {
            if maxLength < minLength {
                print("GridCell: Attempted to set minLength as bigger than maxLength in GridCell. \nValues are equalized instead.")
                minLength = maxLength
            }
        }
    }
    
    var margin: UIEdgeInsets
    
    var spacing: UIEdgeInsets = .zero
    
    init(
        gridLength: GridLength,
        value: CGFloat,
        view: UIView,
        horizontalAlignment: GridHorizontalAlignment,
        verticalAlignment: GridVerticalAlignment,
        maxLength: CGFloat,
        minLength: CGFloat,
        margin: UIEdgeInsets
    ) {
        self.gridLength = gridLength
        self.value = value
        self.view = view
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.maxLength = maxLength
        self.minLength = minLength
        self.margin = margin
    }
}
