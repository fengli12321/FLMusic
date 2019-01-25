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
    
    var token: String?

    let provider: MoyaProvider<NetService>
    
    static func request(_ service: NetService) -> Single<JSON> {
        
        return instance.provider.rx.request(service).filterSuccessfulStatusCodes().catchError({ (error)  in
            
            
            if let error = error as? MoyaError {
                
                var errorDesc = ""
                switch error {
                    
                case .imageMapping(_):
                    errorDesc = "图片"
                case .jsonMapping(_):
                    errorDesc = "json"
                case .stringMapping(_):
                    errorDesc = "string"
                case .objectMapping(_, _):
                    errorDesc = "obj"
                case .encodableMapping(_):
                    errorDesc = "编码"
                case .statusCode(let response):
                    
                    if let data = try? JSON(data: response.data) {
                        
                        let error = data["error"]
                        throw APIError(code: response.statusCode, msg: error.stringValue)
                    } else {
                        errorDesc = "status error"
                    
                    }
                case .underlying(let error, _):
                    
                    let code = error._code
                    if code == -1001 {
                        errorDesc = "请求超时"
                    } else {
                        
                        errorDesc = "其他错误"
                    }
                case .requestMapping(_):
                    errorDesc = "请求错误"
                case .parameterEncoding(_):
                    errorDesc = "请求参数错误"
                }
                
                throw APIError(code: -1, msg: errorDesc)
            } else {
                throw APIError(code: -1, msg: "未知错误")
            }
            
        }).map({ (response)  in
            
            if let data = try? JSON(data: response.data){
                
                return data
            } else {
            
                throw APIError(code: -1, msg: "服务器参数错误")
            }
            
        })
    }
    
    
    override init() {
        

        let requestClosure = { (endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
            do {
                var urlRequest = try endpoint.urlRequest()
                urlRequest.timeoutInterval = 15
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
    case login(username: String, password: String)
    case findList
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
        case .login:
            return "login/"
        case .findList:
            return "musics/"
        }
    
    }
    
    var method: Moya.Method {
        switch self {
        case .smsCode, .register, .login:
            return .post
        case .findList:
            return .get
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
            
        case let .login(username, password):
            return .requestParameters(parameters: ["username": username, "password": password], encoding: URLEncoding.default)
        case .findList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/x-www-form-urlencoded"]
    }
    
    
}
