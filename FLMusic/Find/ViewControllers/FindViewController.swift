//
//  FindViewController.swift
//  FLMusic
//
//  Created by fengli on 2019/1/23.
//  Copyright © 2019 冯里. All rights reserved.
//

import UIKit
import SnapKit
import RxDataSources
import Kingfisher
import MJRefresh
import RxSwift


class FindViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let loadNew = PublishSubject<Void>()
    let loadMore = PublishSubject<Void>()
    
    override var inputType: ViewToViewModelInput.Type? {
        return FindInput.self
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func createUI() {
        
        self.navigationItem.title = "Music"
        self.tableView.backgroundColor = kSecondTintColor
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 15))
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let refreshHeader = MJRefreshNormalHeader { [unowned self] in
            self.loadNew.onNext(())
        }
        refreshHeader?.activityIndicatorViewStyle = .white
        tableView.mj_header = refreshHeader
        
    }
    
    override func provideType() -> MVVMViewModel.Type? {
        return FindViewModel.self
    }
    
    override func rxDrive(viewModelOutput: ViewModelToViewOutput) {
        let output = viewModelOutput as! FindOutput
        
        output.dataSource.drive(tableView.rx.items(cellIdentifier: "cell")) { index, model, cell in

            let cell = cell as! FindListCell
            cell.frontImageView.kf.setImage(with: URL(string: model.image))
            cell.musicNameLabel.text = model.name
            cell.singerLabel.text = model.singer
            cell.albumLabel.text = model.album
        }.disposed(by: disposeBag)
    }

    
}


class FindInput: ViewToViewModelInput {
    
    let loadNew: PublishSubject<Void>
    let loadMore: PublishSubject<Void>
    required init(view: MVVMView) {
        
        let vc = view as! FindViewController
        loadNew = vc.loadNew
        loadMore = vc.loadMore
    }
}
