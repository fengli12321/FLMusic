//
//  FLSearchView.swift
//  FLMusic
//
//  Created by fengli on 2019/1/23.
//  Copyright © 2019 冯里. All rights reserved.
//


import UIKit

class FLSearchView: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createUI() {
        backgroundColor = UIColor.white.withAlphaComponent(0.3)
        layer.cornerRadius = height/2.0
        
        let searchImage = UIImageView(image: UIImage(named: "home_search")?.withRenderingMode(.alwaysOriginal))
        leftView = searchImage
        leftViewMode = .always
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        
        let width: CGFloat = 18.0
        return CGRect(x: 5, y: (self.height - width)/2.0, width: width, height: width)
    }
    //
    //    override func textRect(forBounds bounds: CGRect) -> CGRect {
    //        return super.textRect(forBounds: bounds)
    //    }
}
