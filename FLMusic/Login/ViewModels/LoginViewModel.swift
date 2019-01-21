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
import PKHUD

class LoginViewModel: MVVMViewModel {
    override var outputType: ViewModelToViewOutput.Type? {
        return LoginOutput.self
    }
    
    // 获取验证码
    func getCodeAction(mobile: String) -> Driver<String> {
        
        HUD.show(.labeledProgress(title: nil, subtitle: "加载中"))
        let request = NetworkManager.request(NetService.smsCode(mobile: mobile))
        return request.map({ (data) -> String in
            
            HUD.hide()
            return data["code"].stringValue
        }).asDriver(onErrorRecover: { (error) in
            
            let error = error as! APIError
            HUD.flash(.labeledError(title: "错误", subtitle: error.msg), delay: 2)
            return Driver.empty()
        })
    }
}

struct LoginOutput: ViewModelToViewOutput {
    
    var errorInfo: Driver<String>
    var loginEnable: Driver<Bool>
    var registerEnable: Driver<Bool>
    
    var getCodeEnable: Driver<Bool>
    var getCodeText: Driver<String>
    var getCodeValue: Driver<String>
    
    var requestError = PublishSubject<String>()
    init(viewModel: MVVMViewModel) {
        
        let viewModel = viewModel as! LoginViewModel
        let input = viewModel.input as! LoginInput
        
        // 输入合法性
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
        
        // 注册手机号合法
        let rUserEnable:Driver<Bool> = input.registerUser.map({ (user) -> Bool in
            return user.count == 11
        })
        
        
        // 倒计时
        let timeDuration = 5
        let timer: Driver<Int> = input.getCode.flatMapLatest { _ -> Driver<Int> in
            Observable.timer(0, period: 1, scheduler: MainScheduler.instance)
                .take(timeDuration)
                .asDriver(onErrorJustReturn: 0)
                .map({ (value) -> Int in
                    return (timeDuration - 1 - Int(value))
                })
        }.startWith(0)
        
        // 获取验证码按钮有效
        getCodeEnable = Driver.combineLatest(rUserEnable, timer).map({ (enable, timerValue) -> Bool in
            
            if enable {
                
                return timerValue == 0
            }
            return false
        })
        
        // 验证码按钮文字
        getCodeText = timer.map({ (value) -> String in
            if value == 0 {
                return "获取验证码"
            } else {
                return "\(value)s后重新获取"
            }
        })
        
        
        
        getCodeValue = input.getCode.withLatestFrom(input.registerUser).flatMapLatest({ user in
            return viewModel.getCodeAction(mobile: user)
        })
    }
}
