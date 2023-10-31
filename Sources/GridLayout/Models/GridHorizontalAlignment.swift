//
//  GridHorizontalAlignment.swift
//  GridPanel
//
//  Created by Metin Tarık Kiki on 25.04.2023.
//

import UIKit

public enum GridHorizontalAlignment {
    case fill
    case constantCenter(width: CGFloat)
    case autoCenter
    case constantLeft(width: CGFloat)
    case autoLeft
    case constantRight(width: CGFloat)
    case autoRight
}
