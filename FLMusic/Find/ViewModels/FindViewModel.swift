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
    
    override var outputType: ViewModelToViewOutput.Type? {
        return FindOutput.self
    }
    
    func requestData(_ isMore: Bool) -> Driver<JSON> {
        return NetworkManager.request(.findList).do(onSuccess: {_ in print("=======1========")}, onError: { _ in print("=======2=======")}).map({ (data) in
            return data["results"]
        }).asDriver(onErrorRecover: { (error) in
            
            _ = FLToastView.show("加载失败")
            return Driver.empty()
        })
    }
}

class FindOutput: ViewModelToViewOutput {
    
    let dataSource: Driver<[FindListDataType]>
    required init(viewModel: MVVMViewModel) {
        
        let viewModel = viewModel as! FindViewModel
        let input = viewModel.input as! FindInput
        
        
        
        let loadNew = input.loadNew.flatMapLatest {
            return viewModel.requestData(false)
        }
        let loadMore = input.loadMore.flatMapLatest {
            return viewModel.requestData(true)
        }
        
        dataSource = Observable.merge(loadNew, loadMore).asDriver(onErrorDriveWith: Driver.empty()).map({ data -> [FindListDataType] in
            
            var datas = [FindListDataType]()
            for index in 0..<data.count {
                
                let item = data[index]
                let image = item["image"].stringValue
                let name = item["name"].stringValue
                let album = item["album"].stringValue
                let singer = item["album"].stringValue
                
                datas.append((image: image, name: name, album: "来自专辑：\(album)", singer: singer))
            }
            return datas
        })
        
    }
}

