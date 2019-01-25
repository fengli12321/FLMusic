//
//  FLToastView.swift
//  swift_onlinetreasure
//
//  Created by fengli on 2018/11/27.
//  Copyright © 2018 fengli. All rights reserved.
//

import UIKit
import RxSwift
import Hue

class FLToastView: UIView {

    static let instance = FLToastView()
    
    private var contentLabel: UILabel!;
    private var duration: Double = 2.0
    weak private var timer: Timer!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        
        self.backgroundColor = UIColor(hex: "171a23")
        self.cornerRadius = 5
        
        contentLabel = UILabel()
        contentLabel.textColor = .white
        contentLabel.font = kFont(size: 14)
        self.addSubview(contentLabel)
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        
        
        contentLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
    }
    
    class func show(_ toast: String) -> FLToastView{
        return show(toast, duration: 2.0, inView: kKeyWindow)
    }
    class func show(_ toast: String, duration: Double) -> FLToastView{
        return show(toast, duration: duration, inView: kKeyWindow)
    }
    
    class func show(_ toast: String, inView view: UIView) -> FLToastView{
        return show(toast, duration: 2.0, inView: view)
    }
    
    class func show(_ toast: String, duration: Double, inView view: UIView) -> FLToastView{
        
        instance.duration = duration
        instance.contentLabel.text = toast
        view.addSubview(instance)
        instance.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
        
        instance.alpha = 0
        UIView.animate(withDuration: 0.5) {
            instance.alpha = 0.9
        }
        instance.addTimer()
        return instance
    }
    
    func addTimer() {
        
        let timer = Timer.init(timeInterval: self.duration, target: self, selector: #selector(dismiss), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            self.timer?.invalidate()
            self.timer = nil
        }
    }
}
