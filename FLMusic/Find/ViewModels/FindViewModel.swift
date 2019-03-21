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
    
    let cache = YYDiskCache(path: "\(PathManager.cachePath())/findDatas")
    
    let refreshStatus = BehaviorRelay<FLRefreshStatus>(value: .none)
    
 
    func transform(input: InputType?) -> OutputType? {
    
        let input = input as! FinderInput
        
        
        let new = input.headerRefresh.flatMapLatest { [unowned self] _ in
            return self.requestData(false)
        }
        
        let more = input.footerRefresh.flatMapLatest { [unowned self] _ in
            
            return self.requestData(true)
        }
        
        var cycleData = self.requestCycleData()
        if let cacheData = self.getCycleCache() {
            cycleData = cycleData.startWith(cacheData.arrayValue)
        }
        
        var musics = Driver.merge(new, more)
        
        if let listCache = getListCache() {
            
            self.datas = listCache["results"].arrayValue
            let list = Driver.just(self.datas)
            self.next = listCache["next"].string
            musics = Driver.merge(list, musics)
        }
    
        
        return FindOutput(cycleData: cycleData, musics: musics, refreshStatus: refreshStatus.asDriver())
    }
    
    // 缓存轮播数据
    func cacheCycle(data: JSON) {
        let dataStr = data.rawString() as NSString?
        if let dataStr = dataStr {
            
            self.cache?.setObject(dataStr, forKey: "cycles")
        }
    }
    
    // 获取轮播缓存数据
    func getCycleCache() -> JSON?{
        
        let cacheStr = self.cache?.object(forKey: "cycles")
        
        if let cacheStr = cacheStr {
            
            return JSON(parseJSON: cacheStr as! String)
        }
        return nil
    }
    
    // 请求轮播图数据
    func requestCycleData() -> Driver<[JSON]>{
        
        return NetworkManager.request(.recomment)
            .do(onSuccess: { [unowned self] (data) in
               
                self.cacheCycle(data: data)
            })
            .map({ (data) in
            
            let results = data.arrayValue
            return results
        }).asDriver { (error) in
            return Driver.empty()
        }
    }
    
    
    // 缓存列表数据
    func cacheList(data: JSON) {
        let dataStr = data.rawString() as NSString?
        if let dataStr = dataStr {
            
            self.cache?.setObject(dataStr, forKey: "list")
        }
    }
    
    // 获取列表缓存数据
    func getListCache() -> JSON?{
        
        let cacheStr = self.cache?.object(forKey: "list")
        
        if let cacheStr = cacheStr {
            
            return JSON(parseJSON: cacheStr as! String)
        }
        return nil
    }
    
    // 请求列表数据
    func requestData(_ isMore: Bool) -> Driver<[JSON]> {
        
        let next = isMore ? self.next : nil
        
        return NetworkManager.request(.findList(next: next)).do(onSuccess: { [unowned self] data in
            if !isMore {
                
                self.cacheList(data: data)
            }
        }).map({ [unowned self] (data) in
            
            let results = data["results"]
            self.next = data["next"].string
            let datas = results.arrayValue
            
            if isMore {
                self.datas.append(contentsOf: datas)
            } else {
                self.datas = datas
            }
            
            self.refreshStatus.accept(self.next == nil ? .noMoreData : .endRefresh)
            return self.datas
        }).asDriver(onErrorRecover: { [unowned self] (error) in
            
            _ = FLToastView.show("加载失败")
            
            self.refreshStatus.accept(.endRefresh)
            return Driver.empty()
        })
    }
}


struct FindOutput: OutputType {
    
    var cycleData: Driver<[JSON]>
    var musics: Driver<[JSON]>
    var refreshStatus: Driver<FLRefreshStatus>
}

