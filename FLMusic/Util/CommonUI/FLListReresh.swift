//
//  FLRefreshHeader.swift
//  FLMusic
//
//  Created by fengli on 2019/3/19.
//  Copyright © 2019 冯里. All rights reserved.
//

import UIKit
import MJRefresh


enum FLRefreshStatus {
    case beginHeaderRefresh
    case beginFooterRefresh
    case endRefresh
    case noMoreData
    case none
}

class FLRefreshHeader: MJRefreshGifHeader {

    override func prepare() {
        super.prepare()
        
        
    }
}
