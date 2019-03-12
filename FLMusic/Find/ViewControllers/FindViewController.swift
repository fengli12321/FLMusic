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

class FindViewController: BaseViewController, SDCycleScrollViewDelegate {
    
    
    var collectionView: UICollectionView!
    var cycleView: SDCycleScrollView!
   
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
        
        collectionView.register(FindIntemCell.self, forCellWithReuseIdentifier: "FindIntemCell")
        
        collectionView.register(FinderHeaderCycleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        
        
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
        
//
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Void, JSON>>(
            configureCell: { s, cv, ip, item  in
                
                let cell = cv.dequeueReusableCell(withReuseIdentifier: "FindIntemCell", for: ip) as! FindIntemCell
                cell.listenCountLabel.text = item["like_num"].stringValue
                cell.backImage.kf.setImage(with: URL(string: item["image"].stringValue))
                cell.nameLabel.text = item["name"].stringValue
                return cell
        })
        
        let datas = output.musics.map { (item) in
            return [SectionModel(model: (), items: item)]
        }
//        datas.drive(collectionView.rx.items(dataSource: dataSource)

        datas.asObservable().bind(to: self.collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
       
    }
 

   
}


struct FinderInput: InputType {
    
}

