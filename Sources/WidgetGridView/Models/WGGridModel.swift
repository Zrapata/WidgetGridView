//
//  File.swift
//  File
//
//  Created by Alejandro Bacelis on 20/07/21.
//

import SwiftUI

public struct WGGridModel: Identifiable {
    public var id = UUID()
    public var size: WGSize
    public var cells: [WGCellModel]
    public var columnsForGird: [GridItem]
    public var widgets: [WGWidgetModel] = []
    
    public init(_ size: WGSize) {
        self.size = size
        self.cells = { () -> [WGCellModel] in
            var rCells: [WGCellModel] = []
            
            for i in 0..<size.width {
                for j in 0..<size.height {
                    rCells.append(WGCellModel(id: WGCoordinate(j, i)))
                }
            }
            
            return rCells
        }()
        
        self.columnsForGird = { () -> [GridItem]  in
            var rGrid: [GridItem] = []
            
            for _ in 0..<size.width {
                rGrid.append(GridItem())
            }
            
            return rGrid
        }()
    }
    
    public init(_ size: Int) {
        self.init(WGSize(size))
    }
}

// MARK: Cell Functions
extension WGGridModel {
    func findCell(for cellID: WGCoordinate) throws -> WGCellModel {
        if let foundCell = self.cells.first(where: { $0.id == cellID }) {
            return foundCell
        } else {
            throw Errors.WidgetDoesNotExist
        }
    }
    
    func findCell(for cellIDs: [WGCoordinate]) throws -> [WGCellModel] {
        var storage: [WGCellModel] = []
        do {
            storage = try cellIDs.map({ thisCell in
                do {
                      return try findCell(for: thisCell)
                } catch {
                    throw error
                }
            })
            return storage
        } catch {
            throw error
        }
    }
    
    /// Recive a coordinate in the grid and a size of a widget to return all coordinates of the grid that it will be on, if the widget doesnt fit it will trow an error
    /// - Parameters:
    ///   - id: the ID of a widget as a WGCoordinate
    ///   - withSize: a size of a widget an a WGSize
    /// - Returns: an array of WGCoordinate and thows
    func getCells(startingIn id: WGCoordinate, withSize: WGSize) throws -> [WGCoordinate] {
        let maxWidth = id.width + Int(size.getSize().width) - 1
        let maxHeight = id.height + Int(size.getSize().height) - 1
        let testForID = WGCoordinate(maxWidth, maxHeight)
        
        var ids: [WGCoordinate] = []
        
        if self.cells.firstIndex(where: { $0.id == testForID }) != nil {
            for i in (id.width)..<(maxWidth + 1) {
                for j in (id.height)..<(maxHeight + 1) {
                    ids.append(WGCoordinate(i, j))
                }
            }
        } else {
            throw Errors.WidgetDoesNotFit
        }
        
        return ids
    }
    
    func getEmptyCell() -> some View {
        return Color.blue.frame(WGSize())
    }
}

// MARK: Widgets and Data
extension WGGridModel {
    private func testWidgetFits(_ widget: WGWidgetModel, at cellID: WGCoordinate) throws -> [WGCellModel] {
        do {
            let gridCells = try self.getCells(startingIn: cellID, withSize: widget.size)
            let dataMap = try self.findCell(for: gridCells)
            return dataMap
        } catch {
            throw error
        }
    }
    
    private func getCordsFromWidget(with widget: WGWidgetModel) throws -> [WGCoordinate] {
        do {
            if let widgetCord = self.cells.first(where: { $0.data == widget })?.id {
                let cords = try getCells(startingIn: widgetCord, withSize: widget.size)
                return cords
            } else {
                throw Errors.CoordinateNotFound
            }
        }
    }
    
    mutating private func addDataToCells(cellData: [WGCellModel], for widget: WGWidgetModel) throws -> Void {
        var cellIndices: [Int] = []
        
        for i in cells.indices {
            if cellData.contains(where: { $0.id == cells[i].id }) {
                cellIndices.append(i)
            }
        }
        
        for i in cellIndices {
            if cells[i].hasData {
                throw Errors.GridAlreadyHasValue
            }
            cells[i].hasData = true
        }
        
        cells[cellIndices[0]].data = widget
        cells[cellIndices[0]].isStart = true
    }
    
    mutating private func deleteDataFromCell(cellIDs: [WGCoordinate]) throws -> Void {
        for i in cells.indices {
            if (cellIDs.first(where: { $0 == self.cells[i].id }) != nil) {
                if cells[i].hasData {
                    cells[i].hasData = false
                    cells[i].data = nil
                } else {
                    throw CellErrors.CellWasAlreadyEmpty
                }
            }
        }
    }
    
    mutating private func deleteDataFromCell(widget: WGWidgetModel) throws -> Void {
        do {
            try deleteDataFromCell(cellIDs: getCordsFromWidget(with: widget))
        } catch {
            throw error
        }
    }
    
    mutating func addWidget(_ widget: WGWidgetModel, at cellID: WGCoordinate) throws -> Void {
        do {
           _ = try testWidgetFits(widget, at: cellID)
            
            if let thisWidget = self.cells.first(where: { $0.data == widget }) {
                try deleteDataFromCell(widget: thisWidget.data!)
            }
        }
    }
    
    mutating func deleteWidget(with widgets: [WGWidgetModel]) throws -> Void {
        if widgets.count < 1 {
            throw Errors.NoWidgetIsSelected
        }
        
        do {
            for widget in widgets {
                try deleteDataFromCell(widget: widget)
            }
        } catch {
            throw error
        }
        
        self.widgets.removeAll(where: { widgets.contains($0) })
    }
}



// MARK: Errors
extension WGGridModel {
    enum Errors: Error {
        case WidgetDoesNotExist,
        WidgetDoesNotFit,
        GridAlreadyHasValue,
        NoWidgetIsSelected,
        CoordinateNotFound
    }
    
    enum CellErrors: Error {
        case CellWasAlreadyEmpty
    }
    
    enum WidgetErrors: Error {
        case WidgetSizeDoesNotMatch
    }
}
