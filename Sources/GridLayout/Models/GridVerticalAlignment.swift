//
//  GridVerticalAlignment.swift
//  GridPanel
//
//  Created by Metin Tarık Kiki on 25.04.2023.
//

import UIKit

public enum GridVerticalAlignment {
    case fill
    case constantTop(height: CGFloat)
    case autoTop
    case constantBottom(height: CGFloat)
    case autoBottom
}
