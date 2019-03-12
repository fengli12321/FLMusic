//
//  FindIntemCell.swift
//  FLMusic
//
//  Created by fengli on 2019/3/12.
//  Copyright © 2019 冯里. All rights reserved.
//

import UIKit
import SnapKit

class FindIntemCell: UICollectionViewCell {
    
    var backImage = UIImageView()
    private let listenIcon = UIImageView(image: #imageLiteral(resourceName: "icon_find_listen"))
    var listenCountLabel = UILabel()
    var nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    func createUI() {
        
        addSubview(backImage)
        backImage.contentMode = .scaleAspectFill
        backImage.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        addSubview(listenCountLabel)
        listenCountLabel.textColor = .white
        listenCountLabel.font = kBAutoFont(size: 10)
        listenCountLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kAutoSize(size: 5))
            make.right.equalToSuperview().offset(-kAutoSize(size: 5))
        }
        
        
        addSubview(listenIcon)
        listenIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(listenCountLabel)
            make.right.equalTo(listenCountLabel.snp.left).offset(-kAutoSize(size: 3))
        }
        
        addSubview(nameLabel)
        nameLabel.textColor = .white
        nameLabel.font = kNAutoFont(size: 12)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kAutoSize(size: 10))
            make.bottom.equalToSuperview().offset(-kAutoSize(size: 5))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
