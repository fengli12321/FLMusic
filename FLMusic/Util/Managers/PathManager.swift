//
//  PathManager.swift
//  FLMusic
//
//  Created by fengli on 2019/3/21.
//  Copyright © 2019 冯里. All rights reserved.
//

import UIKit

class PathManager {

    class func cachePath() -> String {
        
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }

}
