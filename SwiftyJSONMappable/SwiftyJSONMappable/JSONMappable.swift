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

    func toJSON() -> JSON

    func toJSONString() -> JSONString?

    // Ignore these property's Name
    func ignoreProperties() -> [String]?

    // Rplace these property's Names with new Names
    func replacedProperties() -> [String: String]?

}

extension JSONConvertibleMappable {

    public func toJSON() -> JSON {

        let mirror = Mirror(reflecting: self)
        var superMirror = mirror.superclassMirror

        guard mirror.children.count > 0 || (superMirror != nil && superMirror!.children.count > 0) else {
            return JSON(self)
        }

        var jsons: [String: JSON] = [:]
        while superMirror != nil {
            for case let (label?, value) in superMirror!.children {
                if self.ignoreProperties() != nil && self.ignoreProperties()!.contains(label) {
                    continue
                }
                if let json = value as? JSONConvertibleMappable {
                    jsons[self.replacedProperties()?[label] ?? label] = json.toJSON()
                }
            }
            superMirror = superMirror?.superclassMirror
        }

        for case let (label?, value) in mirror.children {
            if self.ignoreProperties() != nil && self.ignoreProperties()!.contains(label) {
                continue
            }
            if let json = value as? JSONConvertibleMappable {
                jsons[self.replacedProperties()?[label] ?? label] = json.toJSON()
            }
        }

        return JSON(jsons)
    }

    public func toJSONString() -> String? {
        return toJSON().rawString()
    }

    public func ignoreProperties() -> [String]? {
        return []
    }

    public func replacedProperties() -> [String: String]? {
        return [:]
    }

}

extension Optional: JSONConvertibleMappable {

    public func toJSON() -> JSON {
        if let jSelf = self {
            if let value = jSelf as? JSONConvertibleMappable {
                return value.toJSON()
            }
        }
        return JSON.null
    }

}

extension Array: JSONConvertibleMappable {

    public func toJSON() -> JSON {
        var jsons: [JSON] = []
        for item in self {
            if let item = item as? JSONConvertibleMappable {
               jsons.append(item.toJSON())
            }
        }
        return JSON(jsons)
    }

}

extension Dictionary: JSONConvertibleMappable {

    public func toJSON() -> JSON {
        var jsons: [String: JSON] = [:]
        for (key, value) in self {
            if let key = key as? String {
                if let value = value as? JSONConvertibleMappable {
                    jsons[key] = value.toJSON()
                    continue
                }
                jsons[key] = JSON.null
            }
        }
        return JSON(jsons)
    }

}

extension URL: JSONConvertibleMappable {

    public func toJSON() -> JSON {
        return self.absoluteString.toJSON()
    }

}

extension Date: JSONConvertibleMappable {

    public func toJSON() -> JSON {
        return (self.timeIntervalSince1970 * 1000).toJSON()
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
