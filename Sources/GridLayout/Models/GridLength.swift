//
//  GridLength.swift
//  GridPanel
//
//  Created by Metin Tarık Kiki on 25.04.2023.
//

import UIKit

public enum GridLength {
    case expanded(value: CGFloat,
              view: UIView,
              horizontalAlignment: GridHorizontalAlignment = .fill,
              verticalAlignment: GridVerticalAlignment = .fill,
              margin: UIEdgeInsets = .zero)
    
    case constant(value: CGFloat,
                  view: UIView,
                  horizontalAlignment: GridHorizontalAlignment = .fill,
                  verticalAlignment: GridVerticalAlignment = .fill,
                  margin: UIEdgeInsets = .zero)
    
    case auto(view: UIView,
              horizontalAlignment: GridHorizontalAlignment = .fill,
              verticalAlignment: GridVerticalAlignment = .fill,
              maxSize: CGFloat = 0,
              margin: UIEdgeInsets = .zero)
}
