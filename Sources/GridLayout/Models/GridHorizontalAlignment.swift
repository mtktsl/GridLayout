//
//  GridHorizontalAlignment.swift
//  GridPanel
//
//  Created by Metin Tarık Kiki on 25.04.2023.
//

import UIKit

public enum GridHorizontalAlignment {
    case fill
    case constantLeft(width: CGFloat)
    case autoLeft
    case constantRight(width: CGFloat)
    case autoRight
}
