# SwiftyJSONMappable
Enclose SwiftyJSON which implement: 
 
- **JSON->Model** : Transform JsonString or Dictionary/Array etc to Model, for more information [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

- **Model->JSON** : Transform Model which impements protocol **JSONConvertibleMappable**

[**中文文档**](http://www.jianshu.com/p/5a564585e0ea)

## Installation

You can use cocoapod utility to import it to your Project

``` 
pod 'SwiftyJSONMappable'
```

**Or** : Use it with [Moya](https://github.com/Moya/Moya)

```
pod 'SwiftyJSONMappable/Moya'
```

**Or** : Use it with [RxSwift](https://github.com/ReactiveX/RxSwift)

``` 
pod 'SwiftyJSONMappable/RxSwift'
```

## Usage

### Model define

```
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
```

### Transform to JSON/JSONString

```
let httpBin = ...

let JSON = httpBin.mapJSON()    // transform to SwiftyJSON
let JSONString = httpBin.mapString()   // transform to json String
```

You will get Result like this:

``` 
{
  "headers" : {
    "acceptEncoding" : "gzip;q=1.0, compress;q=0.5",
    "acceptLanguage" : "en;q=1.0",
    "connection" : "close",
    "accept" : "*\/*",
    "host" : "httpbin.org"
  },
  "origin" : "118.113.69.83",
  "args" : {

  },
  "url" : "https:\/\/httpbin.org\/get"
}
```

### Ignore and Replace Property when transfrom to JSON/JSONString

```
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

public var ignoreProperties: [String]? {
	return ["args"]
}

public var replacedProperties: [String : String]? {
	return ["origin": "newOrigin"]
}
```

You will get Result like this:

``` 
{
  "newOrigin" : "118.113.69.83",
  "url" : "https:\/\/httpbin.org\/get",
  "headers" : {
    "acceptEncoding" : "gzip;q=1.0, compress;q=0.5",
    "acceptLanguage" : "en;q=1.0",
    "connection" : "close",
    "accept" : "*\/*",
    "host" : "httpbin.org"
  }
}
```

### Use with Moya

```
MoyaProvider<APIService>().request(.testGet) { (result) in
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
```

### Use with RxSwift

```
RxMoyaProvider<APIService>().request(.testGet)
     .mapJSONMappable(HttpBin.self)
     .observeOn(SerialDispatchQueueScheduler(internalSerialQueueName: "test"))
     .subscribe { (event) in
          switch event {
          case let .next(httpBin):
               print(httpBin.mapString() ?? "请求完毕")
          case let .error(error):
               print(error)
          default:
               print(event)
          }
     }.addDisposableTo(disposeBag)

```


## Author

ApterKing, wangccong@foxmail.com

## License

SwiftyJSONMappable is available under the MIT license. See the LICENSE file for more info.