//
//  MusicPlayerViewController.swift
//  FLMusic
//
//  Created by fengli on 2019/1/30.
//  Copyright © 2019 冯里. All rights reserved.
//

import UIKit
import SwiftyJSON

class MusicPlayerViewController: BaseViewController {

    var music: JSON
    
     init(music: JSON) {
        
        self.music = music
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.music)
    }
}
