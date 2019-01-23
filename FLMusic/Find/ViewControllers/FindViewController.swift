//
//  FindViewController.swift
//  FLMusic
//
//  Created by fengli on 2019/1/23.
//  Copyright © 2019 冯里. All rights reserved.
//

import UIKit
import SnapKit


class FindViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override var inputType: ViewToViewModelInput.Type? {
        return FindInput.self
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
    }
    override func createUI() {
        
        
    }


    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = kMainTintColor
        
        return cell
    }
}


class FindInput: ViewToViewModelInput {
    required init(view: MVVMView) {
        
    }
}
