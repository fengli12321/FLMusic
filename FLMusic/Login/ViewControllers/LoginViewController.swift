//
//  LoginViewController.swift
//  fl_music_ios
//
//  Created by fengli on 2019/1/16.
//  Copyright © 2019 fengli. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Hue
import Hero
import PKHUD

class LoginViewController: BaseViewController {
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var forgetPassBtn: UIButton!
    
    @IBOutlet weak var rUserField: UITextField!
    @IBOutlet weak var rCodeField: UITextField!
    @IBOutlet weak var getCodeBtn: UIButton!
    @IBOutlet weak var rPassField: UITextField!
    @IBOutlet weak var registerActionBtn: UIButton!
    @IBOutlet weak var backLoginBtn: UIButton!
    
    @IBOutlet weak var scrolleLeft: NSLayoutConstraint!
    
    
    var showState = BehaviorRelay(value: 0)  // 展示状态 0 登录 1 注册
    
    override var inputType: ViewToViewModelInput.Type? {
        return LoginInput.self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }
    
    override func createUI() {
        
        backImageView.image = UIImage.coreBlur(inputImage: UIImage(named: "login_bg3.jpg")!, blurNumber: 8)
    
        
        registerBtn.rx.tap.subscribe(onNext: { [unowned self] in
            
            self.login(show: false)
        }).disposed(by: disposeBag)
        
        backLoginBtn.rx.tap.subscribe(onNext: { [unowned self] in
            
            self.login(show: true)
        }).disposed(by: disposeBag)
    }

    override func provideType() -> MVVMViewModel.Type? {
        return LoginViewModel.self
    }
    
    
    override func rxDrive(viewModelOutput: ViewModelToViewOutput) {
        
        let output = viewModelOutput as! LoginOutput
        output.errorInfo.drive(self.errorLabel.rx.text).disposed(by: disposeBag)
        output.loginEnable.drive(self.rx.loginBtnEnable).disposed(by: disposeBag)
        output.registerEnable.drive(self.rx.registerBtnEnable).disposed(by: disposeBag)
        output.getCodeText.drive(self.getCodeBtn.rx.title()).disposed(by: disposeBag)
        output.getCodeEnable.drive(self.getCodeBtn.rx.isEnabled).disposed(by: disposeBag)
        output.getCodeEnable.drive(onNext: { [unowned self] enable in
            
            self.getCodeBtn.setTitleColor(enable ? .black : .darkGray, for: .normal)
        }).disposed(by: disposeBag)
        
        output.getCodeValue.drive(onNext: { (code) in
            HUD.flash(.labeledSuccess(title: "验证码", subtitle: code), delay: 3)
        }).disposed(by: disposeBag)
        
        output.registeSuccess.drive(onNext: { [unowned self] (success, msg) in
            
            if success {
                
                self.login(show: true)
            } else {
                HUD.flash(.labeledError(title: "注册失败", subtitle: msg), delay: 2)
            }
        }).disposed(by: disposeBag)
        
        output.loginSuccess.drive(onNext: { (success, msg) in
            
            if success {
                HUD.flash(.labeledSuccess(title: nil, subtitle: "登录成功"), onView: nil, delay: 1, completion: { _ in
                    
                    let main = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    kKeyWindow.rootViewController = main
                })
            } else {
                HUD.flash(.labeledError(title: "登录失败", subtitle: msg), delay: 2)
            }
        }).disposed(by: disposeBag)
    }
    
    
    
    // MARK: Private
    
    func login(show: Bool) {
        
        let showValue = show ? 0 : 1
        self.showState.accept(showValue)
        
        self.scrolleLeft.constant = show ? 0 : -kScreenWidth
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }

}


extension Reactive where Base : LoginViewController {
    var loginBtnEnable: Binder<Bool> {
        return Binder(self.base) { vc, enable in
            vc.loginBtn.isEnabled = enable
            vc.loginBtn.backgroundColor = enable ? UIColor(hex: "#F24040") : .lightGray
        }
    }
    
    var registerBtnEnable: Binder<Bool> {
        return Binder(self.base) { vc, enable in
            vc.registerActionBtn.isEnabled = enable
            vc.registerActionBtn.backgroundColor = enable ? UIColor(hex: "#F24040") : .lightGray
        }
    }
}

struct LoginInput: ViewToViewModelInput {
    
    let loginUser: Driver<String>
    let loginPass: Driver<String>
    let registerUser: Driver<String>
    let registerCode: Driver<String>
    let registerPass: Driver<String>
    let login: Signal<Void>
    let showState: Driver<Int>
    let getCode: Signal<Void>
    let registeAction: Signal<Void>
    init(view: MVVMView) {
        
        let view = view as! LoginViewController
        
        showState = view.showState.asDriver()
        loginUser = view.userField.rx.text.orEmpty.asDriver()
        loginPass = view.passField.rx.text.orEmpty.asDriver()
        login = view.loginBtn.rx.tap.asSignal()
    
        
        registerUser = view.rUserField.rx.text.orEmpty.asDriver()
        registerCode = view.rCodeField.rx.text.orEmpty.asDriver()
        registerPass = view.rPassField.rx.text.orEmpty.asDriver()
        getCode = view.getCodeBtn.rx.tap.asSignal()
        registeAction = view.registerActionBtn.rx.tap.asSignal()
    }
}
