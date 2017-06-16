//
//  Observable+JSONMappable.swift
//  SwiftyJSONMappable
//
//  Created by wangcong on 15/06/2017.
//  Copyright © 2017 ApterKing. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

public extension ObservableType where E == Response {

    /// Transfrom received data to JSONMappable, fail on error
    public func mapJSONMappable<T: JSONMappable>(_ type: T.Type, failsOnEmptyData: Bool = true) -> Observable<T> {
        return flatMap({ (response) -> Observable<T> in
            return Observable<T>.just(try response.mapJSONMappable(type, failsOnEmptyData: failsOnEmptyData))
        })
    }

    /// Transfrom received data to [JSONMappable], fail on error
    public func mapJSONMappable<T: JSONMappable>(_ type: [T.Type], failsOnEmptyData: Bool = true) -> Observable<[T]> {
        return flatMap({ (response) -> Observable<[T]> in
            return Observable<[T]>.just(try response.mapJSONMappable(type, failsOnEmptyData: failsOnEmptyData))
        })
    }

}
