//: Playground - noun: a place where people can play

// https://medium.com/swift-programming/swift-enums-as-namespace-7df63a17f36f#.whu22x4ki

enum ParseEndpoints {
    case Login(login: String, password: String)
    case CurrentUser
}

extension ParseEndpoints: HTTPEndPointConvertible, HTTPEndPointDSL {
    func toHTTPEndPoint() -> HTTPEndPoint {
        let baseURL = "https://api.parse.com/1"
        
        switch (self) {
        case .Login(let login, let password):
            return GET("\(baseURL)/login") {
                $0.params = ["username": login, "password": password]
            }
        case .CurrentUser:
            return POST("\(baseURL)/users") {
                $0.encoding = .JSON
            }
        }
    }
}

final class EndPointInitializer {
    var params: JSONType = [:]
    var encoding: Alamofire.ParameterEncoding = .URL
}

struct HTTPEndPointConcrete: HTTPEndPoint {
    var resource: String
    var method: Alamofire.Method
    var encoding: Alamofire.ParameterEncoding
    var params: JSONType?
}

protocol HTTPEndPointDSL {
    func GET(resource: String) -> HTTPEndPoint
    func GET(resource: String, @noescape _ block: (initializer: EndPointInitializer) -> ()) -> HTTPEndPoint
    func POST(resource: String, @noescape _ block: (initializer: EndPointInitializer) -> ()) -> HTTPEndPoint
    func PUT(resource: String, @noescape _ block: (initializer: EndPointInitializer) -> ()) -> HTTPEndPoint
    func DELETE(resource: String) -> HTTPEndPoint
}

extension HTTPEndPointDSL {
    func GET(resource: String) -> HTTPEndPoint {
        return HTTPEndPointConcrete(resource: resource,
                                    method: .GET,
                                    encoding: .URLEncodedInURL,
                                    params: nil)
    }
    func GET(resource: String, @noescape _ block: (initializer: EndPointInitializer) -> ()) -> HTTPEndPoint {
        let p = EndPointInitializer()
        block(initializer: p)
        return HTTPEndPointConcrete(resource: resource,
                                    method: .GET,
                                    encoding: .URLEncodedInURL,
                                    params: p.params)
    }
}
