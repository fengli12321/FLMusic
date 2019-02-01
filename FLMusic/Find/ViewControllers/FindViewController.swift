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
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [unowned self] in
            self.loadMore.onNext(())
        })
        
        
        tableView.mj_header.beginRefreshing()
    }
    
    override func provideViewModelType() -> MVVMViewModel.Type? {
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
        
        
        output.refreshStatus.bind(to: self.tableView.rx.refreshStatus).disposed(by: disposeBag)
    
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
            
            self.performSegue(withIdentifier: "musicPlayer", sender: indexPath)
        }).disposed(by: disposeBag)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "musicPlayer" {
            
            
            let indexPath = sender as! IndexPath
            let index = indexPath.row
            let detailVC = segue.destination as! MusicPlayerViewController
            let viewModel = self.viewModel as! FindViewModel
            let data = viewModel.datas[index]
            detailVC.music = data
            
        }
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
