//
//  JSONMappable.swift
//  SwiftyJSONMappable
//
//  Created by wangcong on 14/06/2017.
//  Copyright © 2017 ApterKing. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol JSONMappable: JSONConvertibleMappable {

    init(json: JSON)

}

/// 将Model 转换为 JSON 及 JSONString
/// 通过ignoreProperties() 来忽略掉哪些需要被转换
/// 通过replacedProperties() 来设置将现有的property Name->newName
public protocol JSONConvertibleMappable {

    func toJSON() -> JSON

    func toJSONString() -> String?

    func ignoreProperties() -> [String]?

    func replacedProperties() -> [String : String]?

}

extension JSONConvertibleMappable {

    public func toJSON() -> JSON {

        var results: [String: JSON] = [:]

        let mirror = Mirror(reflecting: self)
        guard mirror.children.count > 0 else {
            return JSON(self)
        }

        var sMirror = mirror.superclassMirror
        while sMirror != nil {
            for case let (label?, value) in sMirror!.children {
                if let json = value as? JSONConvertibleMappable {
                    results[label] = json.toJSON()
                }
            }
            sMirror = sMirror?.superclassMirror
        }

        for case let (label?, value) in mirror.children {
            if let json = value as? JSONConvertibleMappable {
                results[label] = json.toJSON()
            }
        }

        return JSON(results)
    }

    public func toJSONString() -> String? {
        return toJSON().rawString()
    }

    public func ignoreProperties() -> [String]? {
        return nil
    }

    public func replacedProperties() -> [String : String]? {
        return nil
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
        var results: [JSON] = []
        for item in self {
            if let item = item as? JSONConvertibleMappable {
               results.append(item.toJSON())
            }
        }
        return JSON(results)
    }

}

extension Dictionary: JSONConvertibleMappable {

    public func toJSON() -> JSON {
        var results: [String: JSON] = [:]
        for (key, value) in self {
            if let key = key as? String {
                if let value = value as? JSONConvertibleMappable {
                    results[key] = value.toJSON()
                    continue
                }
                results[key] = JSON.null
            }
        }
        return JSON(results)
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
