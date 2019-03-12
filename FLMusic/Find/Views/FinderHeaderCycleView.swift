//
//  HomeHeaderCycleView.swift
//  FLMusic
//
//  Created by fengli on 2019/3/12.
//  Copyright © 2019 冯里. All rights reserved.
//

import UIKit
import SDCycleScrollView
import SwiftyJSON
import Kingfisher

class FinderHeaderCycleView: UICollectionReusableView, SDCycleScrollViewDelegate {

    var cycleView: SDCycleScrollView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var dataSource: [JSON]! {
        willSet {
    
            
            var images = [String]()
            for item in newValue {
                images.append(item["image"].stringValue)
            }
            
            print(images)
            self.cycleView.imageURLStringsGroup = images
        }
    }
   
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        createUI()
    }
    
    func createUI() {
        
        cycleView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kAutoSize(size: 158)), delegate: self, placeholderImage: UIImage())
        cycleView.bannerImageViewContentMode = .scaleAspectFill
        cycleView.autoScrollTimeInterval = 4
        self.addSubview(cycleView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: SDCycleScrollViewDelegate
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        
        print(index)
    }
}
