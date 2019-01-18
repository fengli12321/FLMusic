//
//  FLConst.swift
//  FLMusic_iOS
//
//  Created by 冯里 on 2018/5/10.
//  Copyright © 2018年 fengli. All rights reserved.
//

import UIKit


let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height
let kNotificationCenter = NotificationCenter.default
let kUserDefault = UserDefaults.standard
let kKeyWindow: UIWindow! = UIApplication.shared.delegate!.window!
let STATUS_BAR_HEIGHT = isIphoneX() ? CGFloat(44.0) : CGFloat(20.0)
let NAVIGATION_BAR_HEIGHT = isIphoneX() ? CGFloat(88.0) : CGFloat(64.0)
let TAB_BAR_HEIGHT = isIphoneX() ? CGFloat(49.0 + 34.0) : CGFloat(49.0)
let HOME_INDICATOR_HEIGHT = isIphoneX() ? CGFloat(34.0) : CGFloat(0.0)


func kAutoSize(size: CGFloat) -> CGFloat {
    return size*kScreenWidth/375
}
func kFont(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}
func kBFont(size: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size)
}

func kAutoFont(size: CGFloat) -> UIFont {
    return kFont(size: kAutoSize(size: size))
}

func kBAutoFont(size: CGFloat) -> UIFont {
    return kBFont(size: kAutoSize(size: size))
}

func isIphoneX() -> Bool {
    var isPhoneX = false
    if #available(iOS 11.0, *) {
        let bottom = kKeyWindow.safeAreaInsets.bottom
        if (bottom > 0.0) {
            isPhoneX = true
        }
    } else {
        // Fallback on earlier versions
    }
    return isPhoneX
}


