//
//  File.swift
//  
//
//  Created by Metin Tarık Kiki on 15.01.2024.
//

import Foundation
import OrderedCollections
import CoreGraphics

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.width)
        hasher.combine(self.height)
    }
}

protocol SizeCacheProtocol {
    func performCaching(targetSize: CGSize, result: CGSize)
    func getResult(for targetSize: CGSize) -> CGSize?
    func clearCache()
}

final class SizeCache {
    
    var cache = OrderedDictionary<CGSize, CGSize>()
    let capacity: Int
    
    init(capacity: Int = 10) {
        self.capacity = capacity
    }
}

extension SizeCache: SizeCacheProtocol {
    func performCaching(targetSize: CGSize, result: CGSize) {
        //removing the least read key
        if cache.count == capacity {
            cache.removeFirst()
        }
        cache[targetSize] = result
    }
    
    func getResult(for targetSize: CGSize) -> CGSize? {
        //moving the result into the end of the dictionary
        //to indicate that the result is the most recently read key
        if let result = cache[targetSize] {
            cache.removeValue(forKey: targetSize)
            cache[targetSize] = result
            return result
        } else {
            return nil
        }
    }
    
    func clearCache() {
        cache.removeAll()
    }
}
