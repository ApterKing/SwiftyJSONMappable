//
//  JSONMappable.swift
//  SwiftyJSONMappable
//
//  Created by wangcong on 14/06/2017.
//  Copyright © 2017 ApterKing. All rights reserved.
//

import Foundation
import SwiftyJSON

// A string which can be transformed to JSON
public typealias JSONString = String

// Convert JSON to Model [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
public protocol JSONMappable: JSONConvertibleMappable {

    init(json: JSON)

}

// Represents A Converter Which transforms Model to JSON or JSONString
public protocol JSONConvertibleMappable {

    func mapJSON() -> JSON

    func mapString() -> JSONString?

    // Ignore these property's Name
    var ignoreProperties: [String]? { get }

    // Rplace these property's Names with new Names
    var replacedProperties: [String: String]? { get }

}

extension JSONConvertibleMappable {

    public func mapJSON() -> JSON {

        let mirror = Mirror(reflecting: self)
        var superMirror = mirror.superclassMirror

        guard mirror.children.count > 0 || (superMirror != nil && superMirror!.children.count > 0) else {
            return JSON(self)
        }

        var jsons: [String: JSON] = [:]
        while superMirror != nil {
            for case let (label?, value) in superMirror!.children {
                if self.ignoreProperties != nil && self.ignoreProperties!.contains(label) {
                    continue
                }
                if let json = value as? JSONConvertibleMappable {
                    jsons[self.replacedProperties?[label] ?? label] = json.mapJSON()
                }
            }
            superMirror = superMirror?.superclassMirror
        }

        for case let (label?, value) in mirror.children {
            if self.ignoreProperties != nil && self.ignoreProperties!.contains(label) {
                continue
            }
            if let json = value as? JSONConvertibleMappable {
                jsons[self.replacedProperties?[label] ?? label] = json.mapJSON()
            }
        }

        return JSON(jsons)
    }

    public func mapString() -> String? {
        return mapJSON().rawString()
    }

    public var ignoreProperties: [String]? {
        return []
    }

    public var replacedProperties: [String: String]? {
        return [:]
    }

}

extension Optional: JSONConvertibleMappable {

    public func mapJSON() -> JSON {
        if let jSelf = self {
            if let value = jSelf as? JSONConvertibleMappable {
                return value.mapJSON()
            }
        }
        return JSON.null
    }

}

extension Array: JSONConvertibleMappable {

    public func mapJSON() -> JSON {
        var jsons: [JSON] = []
        for item in self {
            if let item = item as? JSONConvertibleMappable {
               jsons.append(item.mapJSON())
            }
        }
        return JSON(jsons)
    }

}

extension Dictionary: JSONConvertibleMappable {

    public func mapJSON() -> JSON {
        var jsons: [String: JSON] = [:]
        for (key, value) in self {
            if let key = key as? String {
                if let value = value as? JSONConvertibleMappable {
                    jsons[key] = value.mapJSON()
                    continue
                }
                jsons[key] = JSON.null
            }
        }
        return JSON(jsons)
    }

}

extension URL: JSONConvertibleMappable {

    public func mapJSON() -> JSON {
        return self.absoluteString.mapJSON()
    }

}

extension Date: JSONConvertibleMappable {

    public func mapJSON() -> JSON {
        return (self.timeIntervalSince1970 * 1000).mapJSON()
    }

}

extension String: JSONConvertibleMappable {}

extension NSNumber: JSONConvertibleMappable {}

extension Bool: JSONConvertibleMappable {}

extension Float: JSONConvertibleMappable {}

extension Double: JSONConvertibleMappable {}

extension Int: JSONConvertibleMappable {}
extension Int8: JSONConvertibleMappable {}
extension Int16: JSONConvertibleMappable {}
extension Int32: JSONConvertibleMappable {}
extension Int64: JSONConvertibleMappable {}

extension UInt: JSONConvertibleMappable {}
extension UInt8: JSONConvertibleMappable {}
extension UInt16: JSONConvertibleMappable {}
extension UInt32: JSONConvertibleMappable {}
extension UInt64: JSONConvertibleMappable {}
