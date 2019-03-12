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
        let findVC = FindViewController()
        add(viewController: findVC, normalImage: #imageLiteral(resourceName: "icon_tab_find_normal"), selectedImage: #imageLiteral(resourceName: "icon_tab_find_select"), title: "首页")
    }
    
    func createTabBar() {
      
        let images = [#imageLiteral(resourceName: "icon_tab_find_normal"), #imageLiteral(resourceName: "icon_tab_music_normal"), #imageLiteral(resourceName: "icon_tab_user_normal")]
        let selectImages = [#imageLiteral(resourceName: "icon_tab_find_select"), #imageLiteral(resourceName: "icon_tab_music_select"), #imageLiteral(resourceName: "icon_tab_user_select")]
        for (index, vc) in self.viewControllers!.enumerated() {
            vc.tabBarItem.image = images[index].withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = selectImages[index].withRenderingMode(.alwaysOriginal)
        }
    }
    
    func add(viewController: UIViewController, normalImage: UIImage, selectedImage: UIImage, title: String) -> Void {
        
        
        let nav = BaseNavigationController(rootViewController: viewController)
        
        nav.tabBarItem.image = normalImage.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.title = title
        self.addChild(nav)
    }
}
