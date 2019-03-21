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
import Hue
import Kingfisher
import SwiftyJSON
import RxCocoa
import RxSwift
import SDCycleScrollView

class FindViewController: BaseViewController, SDCycleScrollViewDelegate {
    
    
    var collectionView: UICollectionView!
    var cycleView: SDCycleScrollView!
    
    private let headerRefresh = PublishSubject<Void>()
    private let footerRefresh = PublishSubject<Void>()
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func createUI() {
    
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kScreenWidth/3.0, height: kScreenWidth/3.0)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: kAutoSize(size: 158), left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = kBackgroundColor
        view.addSubview(collectionView)
        
        collectionView.register(FindItemCell.self, forCellWithReuseIdentifier: "FindItemCell")
        
        collectionView.register(FinderHeaderCycleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        
        createHeaderView()
        
        
        let header = MJRefreshNormalHeader { [unowned self] in
            
            self.headerRefresh.onNext(())
            self.collectionView.mj_footer.isHidden = true
        }
        
        let footer = MJRefreshAutoNormalFooter { [unowned self] in
            self.footerRefresh.onNext(())
            self.collectionView.mj_header.isHidden = true
        }
        footer?.triggerAutomaticallyRefreshPercent = 2
    
        
        collectionView.mj_header = header
        collectionView.mj_footer = footer
        
        
        collectionView.mj_header.beginRefreshing()
        
        
        createTitleView()
    }
    
    func createTitleView() {
        
        
        let searchButton = FLSearchButton(width: kScreenWidth)
        self.navigationItem.titleView = searchButton
        
    }
    
    
    func createHeaderView() {
        cycleView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kAutoSize(size: 158)), delegate: self, placeholderImage: UIImage())
        cycleView.bannerImageViewContentMode = .scaleAspectFill
        cycleView.autoScrollTimeInterval = 4
        collectionView.addSubview(cycleView)
    }
    
    override func provideInput() -> InputType? {
        return FinderInput(headerRefresh: headerRefresh.asDriver(onErrorJustReturn:()), footerRefresh: footerRefresh.asDriver(onErrorJustReturn: ()))
    }
    
    override func bindViewModel() {
        
        viewModel = FindViewModel()
    
        let output = viewModel?.transform(input: provideInput()) as! FindOutput
        output.cycleData.drive(onNext: { [unowned self] (data) in
            var images = [String]()
            for item in data {
                images.append(item["image"].stringValue)
            }
            
            self.cycleView.imageURLStringsGroup = images
        }).disposed(by: disposeBag)

        
        output.musics.drive(collectionView.rx.items(cellIdentifier: "FindItemCell", cellType: FindItemCell.self), curriedArgument: {index, item, cell in

            cell.listenCountLabel.text = item["like_num"].stringValue
            cell.backImage.kf.setImage(with: URL(string: item["image"].stringValue))
            cell.nameLabel.text = item["name"].stringValue
        
            cell.performAnimation(delay: 0.1*Double(index%12))

        }).disposed(by: disposeBag)
        
        output.musics.drive(onNext: { [unowned self] _ in
            
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        
        output.refreshStatus.drive(onNext: { status in
            
            switch status {

            case .endRefresh:
                
                print("123==============")
                self.collectionView.mj_header.endRefreshing()
                self.collectionView.mj_footer.endRefreshing()
                self.collectionView.mj_header.isHidden = false
                self.collectionView.mj_footer.isHidden = false
            case .noMoreData:
                print("321========================")
                self.collectionView.mj_header.endRefreshing()
                self.collectionView.mj_footer.endRefreshingWithNoMoreData()
                self.collectionView.mj_header.isHidden = false
                self.collectionView.mj_footer.isHidden = false
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
            
            let viewModel = self.viewModel as! FindViewModel
            let item = viewModel.datas[indexPath.row]
            let musicVC = MusicPlayerViewController(music: item)
            self.navigationController?.present(musicVC, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
        
    }
    
    
    
}


struct FinderInput: InputType {
    
    var headerRefresh: Driver<Void>
    var footerRefresh: Driver<Void>
}

