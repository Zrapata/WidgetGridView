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
        self.padding = padding
        
        self.count = width * height
    }
    
    public init(_ size: Int = 1) {
        self.init(size, size)
    }
    
    public func getSize(_ newWidth: Int? = nil, _ newHeigth: Int? = nil) -> CGSize {
        CGSize(
            width: CGFloat((self.multiplier * (newWidth ?? self.width)) + ((newWidth ?? width) - 1) * self.padding),
            height: CGFloat((self.multiplier * (newHeigth ?? self.height)) + ((newHeigth ?? height) - 1) * self.padding))
    }
    
    public func getSize(for size: Int = 1) -> CGSize {
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
}
