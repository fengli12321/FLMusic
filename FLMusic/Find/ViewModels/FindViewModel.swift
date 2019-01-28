//
//  FindViewModel.swift
//  FLMusic
//
//  Created by fengli on 2019/1/23.
//  Copyright © 2019 冯里. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift

typealias FindListDataType = (image: String, name: String, album: String, singer: String)
class FindViewModel: MVVMViewModel{
    
    var datas = [FindListDataType]()
    
    var page = 0
    override var outputType: ViewModelToViewOutput.Type? {
        return FindOutput.self
    }
    var hasMore = true
    func requestData(_ isMore: Bool) -> Driver<[FindListDataType]> {
        
        page = isMore ? page + 1 : 1
        return NetworkManager.request(.findList(page: page)).map({ [unowned self] (data) in
            
            let results = data["results"]
            self.hasMore = data["next"].string != nil
            var datas = [FindListDataType]()
            for index in 0..<results.count {
                
                let item = results[index]
                let image = item["image"].stringValue
                let name = item["name"].stringValue
                let album = item["album"].stringValue
                let singer = item["album"].stringValue
                
                datas.append((image: image, name: name, album: "来自专辑：\(album)", singer: singer))
            }
            if isMore {
                self.datas.append(contentsOf: datas)
            } else {
                self.datas = datas
            }
            return self.datas
        }).asDriver(onErrorRecover: { [unowned self] (error) in
            
            
            self.page = isMore ? self.page - 1 : 0
            _ = FLToastView.show("加载失败")
            return Driver.empty()
        }).do(onCompleted: { [unowned self] in
            
            let output = self.output as! FindOutput
            output._refreshStatus.onNext(self.hasMore ? (isMore ? .endFooterRefresh : .endHeaderRefresh) : .noMoreData)
        })
    }
}

class FindOutput: ViewModelToViewOutput {
    
    let dataSource: Driver<[FindListDataType]>
    fileprivate let _refreshStatus: PublishSubject<RefreshStatus>
    let refreshStatus: Observable<RefreshStatus>
    
    required init(viewModel: MVVMViewModel) {
        
        let viewModel = viewModel as! FindViewModel
        let input = viewModel.input as! FindInput
        
        
        _refreshStatus = PublishSubject<RefreshStatus>()
        refreshStatus = _refreshStatus.asObservable()
        let loadNew = input.loadNew.flatMapLatest {
            return viewModel.requestData(false)
        }
        let loadMore = input.loadMore.flatMapLatest {
            return viewModel.requestData(true)
        }
        
        dataSource = Observable.merge(loadNew, loadMore).asDriver(onErrorDriveWith: Driver.empty())
        
    }
}

