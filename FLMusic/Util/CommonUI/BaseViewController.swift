//
//  BaseViewController.swift
//  fl_music_ios
//
//  Created by fengli on 2019/1/16.
//  Copyright © 2019 fengli. All rights reserved.
//

import UIKit

class BaseViewController: MVVMView {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createUI()
    }
    
    func createUI() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
