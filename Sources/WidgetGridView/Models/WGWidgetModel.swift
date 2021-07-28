//
//  File.swift
//  File
//
//  Created by Alejandro Bacelis on 20/07/21.
//

import SwiftUI
import UniformTypeIdentifiers

let widgetGridWidgetIdentifierString = "com.zrapata.widget-grid.widget"
let widgetGridWidgetIdentifer = UTType(exportedAs: widgetGridWidgetIdentifierString)


public final class WGWidgetModel: NSObject, Identifiable, Codable {
    public var id = UUID()
    public var size: WGSize
    public var type: String
    public var actionable: Bool
    
    public var data: Codable?
    
    public init(_ size: WGSize, type: String, actionable: Bool = false, with data: Codable? = nil) {
        self.size = size
        self.type = type
        self.actionable = actionable
        self.data = data
    }
    
    init(_ widget: WGWidgetModel) {
        self.id = widget.id
        self.size = widget.size
        self.type = widget.type
        self.actionable = widget.actionable
        self.data = widget.data
    }
    
    public convenience init(from decoder: Decoder) throws {
        self.init(coder: decoder as! NSCoder)!
    }
    
    public func encode(to encoder: Encoder) throws {
        _ = try NSKeyedArchiver.archivedData(withRootObject: WGWidgetModel.self, requiringSecureCoding: false)
    }
}

extension WGWidgetModel: NSItemProviderWriting {
    public static var writableTypeIdentifiersForItemProvider: [String] {
        [widgetGridWidgetIdentifierString]
    }
    
    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        do {
            switch typeIdentifier {
            case widgetGridWidgetIdentifierString:
                let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
                _ = try NSKeyedUnarchiver.unarchivedObject(ofClass: WGWidgetModel.self, from: data)
                
                completionHandler(data, nil)
                
                return nil
            default:
                throw Errors.CantWriteWidget
            }
        } catch {
            completionHandler(nil, error)
            return nil
        }
    }
}

extension WGWidgetModel: NSItemProviderReading {
    public static var readableTypeIdentifiersForItemProvider: [String] {
        [widgetGridWidgetIdentifierString]
    }
    
    public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        switch typeIdentifier {
        case widgetGridWidgetIdentifierString:
            guard let widget = try NSKeyedUnarchiver.unarchivedObject(ofClass: WGWidgetModel.self, from: data) else { throw Errors.CantReadWidget }
            return self.init(widget)
            
        default:
            throw Errors.IncorrectDataForReading
        }
    }
    
    
}

extension WGWidgetModel: NSCoding {
    public func encode(with coder: NSCoder) {
        coder.encode(self, forKey: "widget")
    }
    
    public convenience init?(coder: NSCoder) {
        guard let widget = coder.decodeObject(of: WGWidgetModel.self, forKey: "widget") else {
            return nil
        }
        
        self.init(widget)
    }
}

extension WGWidgetModel {
    enum Errors: Error {
        case CantWriteWidget,
             CantReadWidget,
             IncorrectDataForReading
    }
}
