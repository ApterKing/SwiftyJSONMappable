//
//  ViewController.swift
//  SwiftyJSONMappable
//
//  Created by wangcong on 14/06/2017.
//  Copyright © 2017 ApterKing. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // local Test

        if let file = Bundle.main.path(forResource: "SwiftyJSONMappable", ofType: "json") {
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: file)) {
                let json = JSON(data: jsonData)

                let teacher = Teacher(json: json[0])

                // 将Model 转换为 JSON 或者JSONString
                print("\n\n---------------请注意经过中将时间转换为了时间戳-------------------")
                print("\n\(teacher.mapJSON())")

            }
        }

        /* ------------------  网络示例 ------------- */
        MoyaProvider<APIService>().request(.testGet) { (result) in
            print("\n\n--------------- 网络示例非RxSwift -------------------")
            switch result {
            case let .success(response):
                do {
                    let httpBin = try response.mapJSONMappable(HttpBin.self)
                    print(httpBin.mapString() ?? "")
                } catch {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }

//        RxMoyaProvider<APIService>().request(.testGet)
//            .mapJSONMappable(HttpBin.self)
//            .subscribe { (event) in
//                print("\n\n--------------- 网络示例RxSwift -------------------")
//                switch event {
//                case let .next(httpBin):
//                    print(httpBin.mapString() ?? "请求完毕")
//                case let .error(error):
//                    print(error)
//                default:
//                    print(event)
//                }
//            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class Description {

    var description: String?

}

class Teacher: Description, JSONMappable {

    var id: UInt
    var name: String
    var title: String
    var schoolAge: String
    var homePage: URL?
    var courses: [Course]?

    required init(json: JSON) {

        id = json["id"].uIntValue
        name = json["name"].stringValue
        title = json["title"].stringValue
        schoolAge = json["schoolAge"].stringValue
        homePage = URL(string: json["homePage"].stringValue)
        courses = json["courses"].arrayValue.map({ (json) -> Course in
            Course(json: json)
        })

        super.init()
        description = json["description"].stringValue
    }

    public var ignoreProperties: [String]? {
        return ["schoolAge"]
    }

    public var replacedProperties: [String : String]? {
        return ["description": "desc"]
    }

}

class Course: Description, JSONMappable {

    var name: String
    var time: Date

    required init(json: JSON) {
        name = json["name"].stringValue

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: json["time"].stringValue) {
            time = date
        } else {
            time = Date()
        }

        super.init()
        description = json["description"].stringValue
    }

    func ignoreProperties() -> [String]? {
        return ["time"]
    }

    func replacedProperties() -> [String : String]? {
        return ["description": "desc"]
    }

}

/* -------------------------- 网络测试 ------------------ */

enum APIService {
    case testGet
}

extension APIService: TargetType {

    var baseURL: URL {
        return URL(string: "https://httpbin.org/")!
    }

    var path: String {
        switch self {
        case .testGet:
            return "get"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var parameters: [String: Any]? {
        return nil
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var sampleData: Data {
        return "".data(using: .utf8)!
    }

    var task: Task {
        return .request
    }
}

class HttpBinHeaders: JSONMappable {

    var accept: String
    var acceptEncoding: String
    var acceptLanguage: String
    var connection: String
    var host: String

    required init(json: JSON) {
        accept = json["Accept"].stringValue
        acceptEncoding = json["Accept-Encoding"].stringValue
        acceptLanguage = json["Accept-Language"].stringValue
        connection = json["Connection"].stringValue
        host = json["Host"].stringValue
    }

}

class HttpBin: JSONMappable {
    var args: [String: Any]
    var headers: HttpBinHeaders
    var origin: String
    var url: String

    required init(json: JSON) {
        args = json["args"].dictionaryValue
        headers = HttpBinHeaders(json: json["headers"])
        origin = json["origin"].stringValue
        url = json["url"].stringValue
    }
}
