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
import YYCache

class FindViewModel: FLViewModelType{
    
    var datas = [JSON]()
    
    var next: String?
    
 
    func transform(input: InputType?) -> OutputType? {
    
        let cycleData = self.requestCycleData()
        let musics = self.requestData(false)
        
        return FindOutput(cycleData: cycleData, musics: musics)
    }
    
    func requestCycleData() -> Driver<[JSON]>{
        
        return NetworkManager.request(.recomment).do(onSuccess: { (data) in
            
//            let object = data.arrayObject
//            
//            let cache = YYCache(name: "test")
        }).map({ (data) in
            
            let results = data.arrayValue
            return results
        }).asDriver { (error) in
            return Driver.empty()
        }
    }
    
    func requestData(_ isMore: Bool) -> Driver<[JSON]> {
        
        let next = isMore ? self.next : nil
        return NetworkManager.request(.findList(next: next)).map({ [unowned self] (data) in
            
            let results = data["results"]
            self.next = data["next"].string
            let datas = results.arrayValue
            
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
            
        })
    }
}


struct FindOutput: OutputType {
    
    var cycleData: Driver<[JSON]>
    var musics: Driver<[JSON]>
}

