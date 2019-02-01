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
    
    var next: String?
    override var outputType: ViewModelToViewOutput.Type? {
        return FindOutput.self
    }
    func requestData(_ isMore: Bool) -> Driver<[FindListDataType]> {
        
        let next = isMore ? self.next : nil
        return NetworkManager.request(.findList(next: next)).map({ [unowned self] (data) in
            
            let results = data["results"]
            self.next = data["next"].string
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
        }).asDriver(onErrorRecover: { (error) in
            
            _ = FLToastView.show("加载失败")
            return Driver.empty()
        }).do(onCompleted: { [unowned self] in
            
            let output = self.output as! FindOutput
            output._refreshStatus.onNext(self.next != nil ? (isMore ? .endFooterRefresh : .endHeaderRefresh) : .noMoreData)
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

