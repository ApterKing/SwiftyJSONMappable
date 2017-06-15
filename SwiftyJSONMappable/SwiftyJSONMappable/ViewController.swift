//
//  ViewController.swift
//  SwiftyJSONMappable
//
//  Created by wangcong on 14/06/2017.
//  Copyright © 2017 ApterKing. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let file = Bundle.main.path(forResource: "SwiftyJSONMappable", ofType: "json") {
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: file)) {
                let json = JSON(data: jsonData)

                let teacher = Teacher(json: json[0])

                print("----------------------------------")
                print("姓名：\(teacher.name)      职称：\(teacher.title)")

                // 将Model 转换为 JSON 或者JSONString
                print("\n\n---------------请注意经过中将时间转换为了时间戳-------------------")
                print("\n\(teacher.toJSON())")

                print("\n\n----------------------------------")
                print("\n\(teacher.courses?.toJSONString() ?? "")")
            }
        }

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
