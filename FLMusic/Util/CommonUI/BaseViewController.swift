//
//  BaseViewController.swift
//  fl_music_ios
//
//  Created by fengli on 2019/1/16.
//  Copyright © 2019 fengli. All rights reserved.
//

import UIKit
import Hue
import RxSwift

enum FLButtonBarItemType {
    case text    // 文本
    case image   // 图片
}

class BaseViewController: UIViewController, FLViewType {
    
    
    var viewModel: FLViewModelType?
    
    func provideInput() -> InputType? {
        return nil
    }
    

    
    let disposeBag = DisposeBag()
    
    var translucentNav: Bool!{
        didSet {
            if let navigationBar = self.navigationController?.navigationBar {
                var image: UIImage? = nil
                var shadowImage: UIImage?
                if translucentNav {
                    image = UIImage()
                    shadowImage = UIImage()
                } else {
                    shadowImage = UIImage()
                }
                
                
                navigationBar.setBackgroundImage(image, for: .default)
                navigationBar.shadowImage = shadowImage
            }
        }
    }  // 是否透明导航栏
    var hiddenBack: Bool!{
        didSet {
            if let nav = self.navigationController as? BaseNavigationController  {
                nav.backButton?.isHidden = hiddenBack
            }
        }
    }// 是否隐藏返回按钮
    var rightSwipeEnable: Bool!{
        didSet {
            if let nav = self.navigationController as? BaseNavigationController {
                
                nav.interactivePopGestureRecognizer?.isEnabled = rightSwipeEnable
            }
        }
    }// 右滑返回手势是否有效
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kBackgroundColor
        self.translucentNav = false
        self.rightSwipeEnable = true
        self.hiddenBack = false
        // Do any additional setup after loading the view.
        createUI()
        bindViewModel()
    }
    
    func createUI() {
        
    }
    
    func bindViewModel() {
        
    }
    

    
    func addButtonBar(type: FLButtonBarItemType, isLeft: Bool, title: String?, image: String?, action: Selector, textAttributes: [NSAttributedString.Key : Any]?) -> UIBarButtonItem? {
        
        let item: UIBarButtonItem?
        switch type {
            
        case .text:
            let textItem = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
            textItem.setTitleTextAttributes(textAttributes, for: .normal)
            item = textItem
        case .image:
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            button.setImage(UIImage(named: image!), for: .normal)
            button.addTarget(self, action: action, for: .touchUpInside)
            button.contentHorizontalAlignment = isLeft ? .left : .right
            let imageItem = UIBarButtonItem(customView: button)
            item = imageItem
        }
        if isLeft {
            self.navigationItem.leftBarButtonItem = item
        } else {
            self.navigationItem.rightBarButtonItem = item
        }
        return item
    }
    
    
    func addImageItem(image: String, isLeft: Bool, action: Selector) -> UIBarButtonItem? {
        return self.addButtonBar(type: .image, isLeft: isLeft, title: nil, image: image, action: action, textAttributes: nil)
    }
    
    func addTitleItem(title: String, isLeft: Bool, action: Selector) -> UIBarButtonItem? {
        return self.addButtonBar(type: .text, isLeft: isLeft, title: title, image: nil, action: action, textAttributes: nil)
    }
    
    func addTitleItem(title: String, isLeft: Bool, action: Selector, titleColor: UIColor) -> UIBarButtonItem? {
        return self.addButtonBar(type: .text, isLeft: isLeft, title: title, image: nil, action: action, textAttributes: [.foregroundColor : titleColor])
    }


}
