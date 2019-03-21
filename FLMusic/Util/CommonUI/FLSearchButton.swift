//
//  FLSearchButton.swift
//  FLMusic
//
//  Created by fengli on 2019/3/21.
//  Copyright © 2019 冯里. All rights reserved.
//

import UIKit
import Hue

class FLSearchButton: UIView {
    
    var searchButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func createUI() {
        
        searchButton = UIButton()
        addSubview(searchButton)
    }
    
}
