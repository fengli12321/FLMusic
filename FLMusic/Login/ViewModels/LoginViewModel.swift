//
//  LoginViewModel.swift
//  fl_music_ios
//
//  Created by fengli on 2019/1/17.
//  Copyright © 2019 fengli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewModel: MVVMViewModel {
    override var outputType: ViewModelToViewOutput.Type? {
        return LoginOutput.self
    }
    
    // 获取验证码
    func getCodeAction(mobile: String) -> Driver<String> {
        
        let request = NetworkManager.request(NetService.smsCode(mobile: mobile))
        return request.map({ (data) -> String in
            return "123321"
        }).asDriver(onErrorRecover: { (error) in
            
            print(error)
            return Driver.empty()
        })
    }
}

struct LoginOutput: ViewModelToViewOutput {
    
    var errorInfo: Driver<String>
    var loginEnable: Driver<Bool>
    var registerEnable: Driver<Bool>
    
    var getCodeEnable: Driver<Bool>
    var getCodeValue: Driver<String>
    init(viewModel: MVVMViewModel) {
        
        let viewModel = viewModel as! LoginViewModel
        let input = viewModel.input as! LoginInput
        
        errorInfo = Driver.combineLatest(input.loginUser, input.loginPass, input.registerUser, input.registerCode, input.registerPass, input.showState).map { (user, passwd, rUser, rCode, rPass, showState) in
            
            
            if showState == 0 {
                if user.count == 0 {
                    return "请输入用户名"
                }
                if passwd.count == 0 {
                    return "请输入密码"
                }
            } else {
                if rUser.count == 0 {
                    return "请输入用户名"
                }
                if rCode.count != 6 {
                    return "请输入正确的验证码"
                }
            
                if rPass.count == 0 {
                    return "请确认密码"
                }
                
                if rPass.count < 6 {
                    return "密码强度不足"
                }
            }
            
            
            return ""
        }
        
        loginEnable = errorInfo.map({ (error) in
            return error.count == 0
        })
        
        registerEnable = loginEnable
        
        getCodeEnable = input.registerUser.map({ (user) -> Bool in
            return user.count == 11
        })
        
        getCodeValue = input.getCode.withLatestFrom(input.registerUser).flatMapLatest({ user in
            return viewModel.getCodeAction(mobile: user)
        })
    }
}
