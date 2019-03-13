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
import SDCycleScrollView
import Hero

class FindViewController: BaseViewController, SDCycleScrollViewDelegate, UICollectionViewDataSource {
    
    
    var collectionView: UICollectionView!
    var cycleView: SDCycleScrollView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func createUI() {
        
        self.hero.isEnabled = true
        self.view.hero.isEnabled = true
        
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
        
        collectionView.dataSource = self
        createHeaderView()
    }
    
    func createHeaderView() {
        cycleView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kAutoSize(size: 158)), delegate: self, placeholderImage: UIImage())
        cycleView.bannerImageViewContentMode = .scaleAspectFill
        cycleView.autoScrollTimeInterval = 4
        collectionView.addSubview(cycleView)
    }
    
    override func provideInput() -> InputType? {
        return nil
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

        
//        output.musics.drive(collectionView.rx.items(cellIdentifier: "FindItemCell", cellType: FindItemCell.self), curriedArgument: {index, item, cell in
//
//            cell.listenCountLabel.text = item["like_num"].stringValue
//            cell.backImage.kf.setImage(with: URL(string: item["image"].stringValue))
//            cell.nameLabel.text = item["name"].stringValue
//
//            cell.hero.id = "image_\(index)"
//            cell.backImage.hero.modifiers = [.fade, .position(CGPoint(x: 5, y: 5))]
//        }).disposed(by: disposeBag)
        
        output.musics.drive(onNext: { [unowned self] _ in
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
            
            let viewModel = self.viewModel as! FindViewModel
            let item = viewModel.datas[indexPath.row]
            let musicVC = MusicPlayerViewController(music: item)
            self.navigationController?.present(musicVC, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let viewModel = self.viewModel as? FindViewModel
        return viewModel?.datas.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FindItemCell", for: indexPath) as! FindItemCell
        let viewModel = self.viewModel as! FindViewModel
        let item = viewModel.datas[indexPath.row]
        
        cell.listenCountLabel.text = item["like_num"].stringValue
        cell.backImage.kf.setImage(with: URL(string: item["image"].stringValue))
        cell.nameLabel.text = item["name"].stringValue
        
        cell.hero.id = "image_\(index)"
        cell.backImage.hero.modifiers = [.fade, .position(CGPoint(x: 5, y: 5))]
        return cell
    }
}


struct FinderInput: InputType {
    
}

