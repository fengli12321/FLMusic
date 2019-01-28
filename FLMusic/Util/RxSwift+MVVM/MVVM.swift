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

typealias RequstData<T> = (success: Bool, data: T)

// MARK: Protocol
protocol ViewToViewModelInput {
    init(view: MVVMView)
}


protocol ViewModelToViewOutput {
    init(viewModel: MVVMViewModel)
}


protocol ViewToViewModelInputProvider {
    var inputType: ViewToViewModelInput.Type? { get }
    func provideInput() -> ViewToViewModelInput?
}

extension ViewToViewModelInputProvider where Self: MVVMView {
    func provideInput() -> ViewToViewModelInput? {
        return self.inputType?.init(view: self)
    }
}


protocol ViewModelToViewOutputProvider {
    var outputType: ViewModelToViewOutput.Type? { get }
    func provideOutput() -> ViewModelToViewOutput?
}

extension ViewModelToViewOutputProvider where Self: MVVMViewModel {
    func provideOutput() -> ViewModelToViewOutput? {
        let output = self.outputType?.init(viewModel: self)
        self.output = output
        return output
    }
}

// MARK: View & ViewModel
class MVVMView: UIViewController, ViewToViewModelInputProvider {
    
    private var viewModelType: MVVMViewModel.Type?
//    private(set) var router: Router!
    var viewModel: MVVMViewModel?
    var inputType: ViewToViewModelInput.Type? { return nil }
    var receive: Driver<Any>?
    
    required init(_ viewModelType: MVVMViewModel.Type?) {
        self.viewModelType = viewModelType
        super.init(nibName: nil, bundle: nil)
//        self.router = Router(from: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
//        self.router = Router(from: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let viewModeType = provideViewModelType() {
            
            self.viewModelType = viewModeType
        }
        
        if let viewModelType = self.viewModelType, let input = self.provideInput() {
            self.viewModel = viewModelType.init(input: input)
            if let output = self.viewModel!.provideOutput() {
                rxDrive(viewModelOutput: output)
            }
        }
    }
    
    func provideViewModelType() -> MVVMViewModel.Type? {
        return nil
    }
    
    func rxDrive(viewModelOutput: ViewModelToViewOutput) {
        print("抽象方法,在此进行绑定,此方法必须重写!")
    }
    func provideCallBack() -> Driver<Any>? { return nil }
    
    let disposeBag = DisposeBag()
}

class MVVMViewModel: NSObject, ViewModelToViewOutputProvider {
    let input: ViewToViewModelInput
    var output: ViewModelToViewOutput!
    var outputType: ViewModelToViewOutput.Type? { return nil }
    required init(input: ViewToViewModelInput) {
        self.input = input
    }
}

enum RefreshStatus {
    case none
    case beingHeaderRefresh
    case endHeaderRefresh
    case beingFooterRefresh
    case endFooterRefresh
    case noMoreData
}


extension Reactive where Base: UIScrollView {
    
    /// Bindable sink for `text` property.
    var refreshStatus: Binder<RefreshStatus> {
        return Binder(self.base) { scrollView, status in
            switch status {
                
            case .none:
                break
            case .beingHeaderRefresh:
                scrollView.mj_header.beginRefreshing()
            case .endHeaderRefresh:
                scrollView.mj_header.endRefreshing()
            case .beingFooterRefresh:
                scrollView.mj_footer.beginRefreshing()
            case .endFooterRefresh:
                scrollView.mj_footer.endRefreshing()
            case .noMoreData:
                scrollView.mj_footer.endRefreshingWithNoMoreData()
            }
            
            if status != .noMoreData {
                scrollView.mj_footer.resetNoMoreData()
            }
        }
    }
}


//
//struct MVVMUnit {
//    let viewType: MVVMView.Type
//    let viewModelType: MVVMViewModel.Type
//}
//
//extension MVVMUnit: ExpressibleByArrayLiteral {
//    typealias ArrayLiteralElement = AnyClass
//
//    init(arrayLiteral elements: ArrayLiteralElement...) {
//        assert(elements.count == 2, "初始化长度错误")
//        let viewType = elements[0] as? MVVMView.Type
//        assert(viewType != nil, "vimeType 错误")
//        let viewModelType = elements[1] as? MVVMViewModel.Type
//        assert(viewModelType != nil, "viewModelType 错误")
//        self.viewType = viewType!
//        self.viewModelType = viewModelType!
//    }
//}
//
//struct MVVMUnitCase: RawRepresentable {
//    typealias RawValue = MVVMUnit
//    let rawValue: MVVMUnit
//    public init(rawValue: RawValue) {
//        self.rawValue = rawValue
//    }
//}

//extension MVVMUnitCase {
//
//}
//
//struct MVVMBinder {
//    static func obtainBindedView(_ unitCase: MVVMUnitCase) -> MVVMView{
//        let unit = unitCase.rawValue
//        let viewType = unit.viewType
//        let viewModelType = unit.viewModelType
//        let view = viewType.init(viewModelType)
//        return view
//    }
//}
//
//enum RouterType {
//    case push(MVVMUnitCase)
//    case present(MVVMUnitCase)
//    case root(MVVMUnitCase)
//    case back
//}
//struct Router {
//    let from: MVVMView
//    init(from: MVVMView) {
//        self.from = from
//    }
//    func route(_ type: RouterType, send: Driver<Any>? = nil) -> Driver<Any>? {
//        switch type {
//
//        case let .push(unitCase):
//            let view = MVVMBinder.obtainBindedView(unitCase)
//            view.receive = send
//            from.navigationController?.pushViewController(view, animated: true)
//            return view.provideCallBack()
//
//        case let .present(unitCase):
//            let view = MVVMBinder.obtainBindedView(unitCase)
//            view.receive = send
//            from.present(view, animated: true, completion: nil)
//            return view.provideCallBack()
//
//        case let .root(unitCase):
//            let view = MVVMBinder.obtainBindedView(unitCase)
//            view.receive = send
//            UIApplication.shared.keyWindow?.rootViewController = view
//            return view.provideCallBack()
//
//        case .back:
//            if from.presentationController != nil {
//                from.dismiss(animated: true, completion: nil)
//            } else {
//                _ = from.navigationController?.popViewController(animated: true)
//            }
//            return nil
//
//        }
//    }
//}

