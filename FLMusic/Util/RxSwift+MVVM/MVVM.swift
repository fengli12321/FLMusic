//
//  Protocols.swift
//  fl_music_ios
//
//  Created by fengli on 2019/1/17.
//  Copyright © 2019 fengli. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift



protocol FLViewModelType {
    
    func transform(input: InputType?) -> OutputType?
}

protocol FLViewType {
    func provideInput() -> InputType?
}


protocol InputType {
    
}

protocol OutputType {
    
}
