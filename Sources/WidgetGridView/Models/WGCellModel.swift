//
//  File.swift
//  File
//
//  Created by Alejandro Bacelis on 20/07/21.
//

import SwiftUI

public struct WGCellModel: Identifiable, Hashable {
    public var id: WGCoordinate
    public var hasData: Bool
    public var data: WGWidgetModel?
    public var isStart: Bool
    
    public init(id: WGCoordinate) {
        self.id = id
        self.hasData = false
        self.isStart = false
    }
    
    mutating func addData(with size: WGWidgetModel, isStart: Bool = false) {
        self.hasData = true
        self.data = size
        self.isStart = isStart
    }
}
