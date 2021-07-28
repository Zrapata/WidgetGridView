//
//  File.swift
//  File
//
//  Created by Alejandro Bacelis on 20/07/21.
//

import SwiftUI

public struct WGCoordinate: Equatable, Hashable {
    public var width: Int = 0
    public var height: Int = 0
    
    public init(_ width: Int, _ height: Int) {
        self.width = width
        self.height = height
    }
    
    public init(at point: CGPoint) {
        self.width = Int(floor(point.x / CGFloat(WGSize().multiplier + WGSize().padding)))
        self.width = Int(floor(point.y / CGFloat(WGSize().multiplier + WGSize().padding)))
    }
}
