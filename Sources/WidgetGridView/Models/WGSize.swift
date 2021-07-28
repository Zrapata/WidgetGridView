//
//  File.swift
//  File
//
//  Created by Alejandro Bacelis on 20/07/21.
//

import SwiftUI

public struct WGSize: Codable {
    
    public var multiplier: Int
    public var padding: Int
    
    public var width: Int
    public var height: Int
    
    public var count: Int
    
    public init(_ width: Int, _ height: Int, multiplier: Int = 75, padding: Int = 5) {
        self.width = width
        self.height = height
        self.multiplier = multiplier
        self.padding = padding < 0 ? 0 : padding
        
        self.count = width * height
    }
    
    public init(_ width: Int = 3, _ height: Int = 5, multiplier: Int = 75, padding: Int = 5, with geometry: GeometryProxy, for parameter: Parameters) {
        
        var newWidth = width
        var newHeight = height
        var newPadding = padding
        var newMultiplier = multiplier
        
        switch parameter {
        case .width:
            newWidth = Int(geometry.size.width / CGFloat(multiplier + padding))
        case .height:
            newHeight = Int(geometry.size.height / CGFloat(multiplier + padding))
        case .padding:
            newPadding = Int((geometry.size.width - (CGFloat(width * multiplier))) / CGFloat((width - 2)))
        case .multiplier:
            newMultiplier = Int((geometry.size.width - CGFloat(width * padding)) / CGFloat(width))
        }
        
        self.init(newWidth, newHeight, multiplier: newMultiplier, padding: newPadding)
    }
    
    public init(_ size: Int = 1) {
        self.init(size, size)
    }
    
    public init(_ width: Int, _ height: Int, with config: WGSize) {
        self.init(width, height, multiplier: config.multiplier, padding: config.padding)
    }
    
    public func getSize(_ newWidth: Int? = nil, _ newHeigth: Int? = nil) -> CGSize {
        CGSize(
            width: CGFloat((self.multiplier * (newWidth ?? self.width)) + ((newWidth ?? width) - 1) * self.padding),
            height: CGFloat((self.multiplier * (newHeigth ?? self.height)) + ((newHeigth ?? height) - 1) * self.padding))
    }
    
    public func getSize(for size: Int) -> CGSize {
        return self.getSize(size, size)
    }
    
    public func getView() -> some View {
        Color.green
            .opacity(0.7)
            .frame(self.getSize())
    }
    
    public func getPadding() -> CGFloat {
        return CGFloat(padding)
    }
    
    public enum Parameters {
        case width, height, padding, multiplier
    }
    
    
}
