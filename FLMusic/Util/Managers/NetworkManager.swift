//
//  NetworkManager.swift
//  fl_music_ios
//
//  Created by fengli on 2019/1/18.
//  Copyright © 2019 fengli. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import SwiftyJSON


struct APIError: Swift.Error {
    let code: Int
    var msg = ""
}
class NetworkManager: NSObject {
    
    static let instance = NetworkManager()
    
    

    let provider: MoyaProvider<NetService>
    
    static func request(_ service: NetService) -> Single<JSON> {
        
        return instance.provider.rx.request(service).map({ (response)  in
            
            let statusCode = response.statusCode
            let data = try JSON(data: response.data)
            if statusCode/200 == 1 {
                
                return data
            } else {
                
                let first = data.first
                var msg = "未知错误"
                if let first = first {
                    let (_, msgs) = first
                    msg = msgs[0].stringValue
                }
                throw APIError(code: -1, msg: msg)
            }
            
        })
    }
    
    
    override init() {
//        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
//        configuration.timeoutIntervalForRequest = 10
//        let manager = Manager(configuration: configuration)
//        manager.startRequestsImmediately = false

        let requestClosure = { (endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
            do {
                var urlRequest = try endpoint.urlRequest()
                urlRequest.timeoutInterval = 1
                closure(.success(urlRequest))
            } catch MoyaError.requestMapping(let url) {
                closure(.failure(MoyaError.requestMapping(url)))
            } catch MoyaError.parameterEncoding(let error) {
                closure(.failure(MoyaError.parameterEncoding(error)))
            } catch {
                closure(.failure(MoyaError.underlying(error, nil)))
            }
        }
        
        provider = MoyaProvider<NetService>(requestClosure: requestClosure)
        super.init()
    }
}


enum NetService {
    case smsCode(mobile: String)
    case register(mobile: String, password: String, code: String)
}

extension NetService: TargetType {
    var baseURL: URL {
        let urlStr = "http://172.30.15.49:8000"
        return URL(string: urlStr)!
    }
    
    var path: String {
        switch self {
        case .smsCode:
            return "getsmscode/"
        case .register:
            return "register/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .smsCode, .register:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .register(mobile, password, code):
            return .requestParameters(parameters: ["mobile" : mobile, "password" : password, "code" : code], encoding: URLEncoding.default)
        case .smsCode(let mobile):
            return .requestParameters(parameters: ["mobile" : mobile], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/x-www-form-urlencoded"]
    }
    
    
}
