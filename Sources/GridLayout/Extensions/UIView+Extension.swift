//
//  File.swift
//  
//
//  Created by Metin Tarık Kiki on 31.05.2023.
//

import UIKit

public extension UIView {
    func auto() -> GridAutoCellProtocol {
        return GridAutoCell(
            cell: .init(
                gridLength: .auto,
                value: .zero,
                view: self,
                horizontalAlignment: .fill,
                verticalAlignment: .fill,
                maxLength: .infinity,
                minLength: .zero,
                margin: .zero
            )
        )
    }
    
    func constant(_ value: CGFloat) -> GridContentProtocol {
        return GridConstantCell(
            cell: .init(
                gridLength: .constant,
                value: value,
                view: self,
                horizontalAlignment: .fill,
                verticalAlignment: .fill,
                maxLength: .infinity,
                minLength: .zero,
                margin: .zero
            )
        )
    }
    
    func expanded(_ value: CGFloat = 1) -> GridContentProtocol {
        return GridExpandedCell(
            cell: .init(
                gridLength: .expanded,
                value: value,
                view: self,
                horizontalAlignment: .fill,
                verticalAlignment: .fill,
                maxLength: .infinity,
                minLength: .zero,
                margin: .zero
            )
        )
    }
}

