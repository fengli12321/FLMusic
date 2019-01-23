//
//  BaseNavigationController.swift
//  FLMusic
//
//  Created by fengli on 2019/1/23.
//  Copyright © 2019 冯里. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    var backButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
    
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        if self.viewControllers.count > 1 {
            let backButton = UIButton(type: .custom)
            backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            backButton.setImage(UIImage(named: "icon_back_white"), for: .normal)
            backButton.addTarget(viewController, action: #selector(backTo), for: .touchUpInside)
            backButton.contentHorizontalAlignment = .left
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//            self.backTo()
            
            self.backButton = backButton
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.interactivePopGestureRecognizer?.isEnabled = true
        
        if viewController.isKind(of: BaseViewController.self) {
            let vc = viewController as! BaseViewController
            self.interactivePopGestureRecognizer?.isEnabled = vc.rightSwipeEnable
        }
        
        if self.viewControllers.count == 1 {
            self.interactivePopGestureRecognizer?.isEnabled = false
            self.interactivePopGestureRecognizer?.delegate = nil
        }
    }
}


extension UIViewController {
    
    @objc func backTo() {
        self.navigationController?.popViewController(animated: true)
    }
}
