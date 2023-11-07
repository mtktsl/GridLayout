//
//  GridContentProtocol.swift
//
//
//  Created by Metin Tarık Kiki on 2.11.2023.
//

import UIKit

public protocol GridContentProtocol: AnyObject {
    func horizontalAlignment(_ alignment: GridHorizontalAlignment) -> GridContentProtocol
    func verticalAlignment(_ alignment: GridVerticalAlignment) -> GridContentProtocol
    func margin(_ margin: UIEdgeInsets) -> GridContentProtocol
    func getInstance() -> GridContentBase
}
