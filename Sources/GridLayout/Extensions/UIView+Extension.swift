//
//  File.swift
//  
//
//  Created by Metin Tarık Kiki on 31.05.2023.
//

import UIKit

public extension UIView {
    func Auto(
        horizontalAlignment: GridHorizontalAlignment = .fill,
        verticalAlignment: GridVerticalAlignment = .fill,
        margin: UIEdgeInsets = .zero
    ) -> Auto {
        return .init(
            horizontalAlignment: horizontalAlignment,
            verticalAlignment: verticalAlignment,
            margin: margin) { self }
    }
    
    func Constant(
        value: CGFloat,
        horizontalAlignment: GridHorizontalAlignment = .fill,
        verticalAlignment: GridVerticalAlignment = .fill,
        margin: UIEdgeInsets = .zero
    ) -> Constant {
        return .init(
            value: value,
            horizontalAlignment: horizontalAlignment,
            verticalAlignment: verticalAlignment,
            margin: margin) { self }
    }
    
    func Expanded(
        value: CGFloat = 1,
        horizontalAlignment: GridHorizontalAlignment = .fill,
        verticalAlignment: GridVerticalAlignment = .fill,
        margin: UIEdgeInsets = .zero
    ) -> Expanded {
        return .init(
            value: value,
            horizontalAlignment: horizontalAlignment,
            verticalAlignment: verticalAlignment,
            margin: margin) { self }
    }
}
