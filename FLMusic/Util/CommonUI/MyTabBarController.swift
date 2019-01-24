//
//  MyTabBarViewController.swift
//  FLMusic
//
//  Created by fengli on 2019/1/23.
//  Copyright © 2019 冯里. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
    }
    
    func createTabBar() {
        
        let images = [#imageLiteral(resourceName: "icon_tab_find_normal"), #imageLiteral(resourceName: "icon_tab_music_normal"), #imageLiteral(resourceName: "icon_tab_user_normal")]
        let selectImages = [#imageLiteral(resourceName: "icon_tab_find_select"), #imageLiteral(resourceName: "icon_tab_music_select"), #imageLiteral(resourceName: "icon_tab_user_select")]
        for (index, vc) in self.viewControllers!.enumerated() {
            vc.tabBarItem.image = images[index].withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = selectImages[index].withRenderingMode(.alwaysOriginal)
        }
    }
}
