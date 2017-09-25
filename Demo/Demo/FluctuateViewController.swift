//
//  ViewController.swift
//  Demo
//
//  Created by Yoshimasa Sakuragi on 2017/09/24.
//  Copyright © 2017年 Yoshimasa Sakuragi. All rights reserved.

import UIKit

open class FluctuateViewController: UIViewController {
    
    public var fluctuateView: FluctuateView!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        fluctuateView = FluctuateView(frame: self.view.frame)
        fluctuateView.dataSource = self
        fluctuateView.delegate = self
        self.view.addSubview(fluctuateView)
    }
}

extension FluctuateViewController : FluctuateViewDataSource {
    
    open func contentsCount() -> Int { return 3}
    
    open func fluctuateView(_ fluctuateView: FluctuateView, contentTitle index: Int) -> String {
        return "\(index)"
    }
    open func fluctuateView(_ fluctuateView: FluctuateView, contentByIndex index: Int) -> UIViewController {
        
        switch index {
        case 0:
            return UIStoryboard(name: "FixedVCDemoVC", bundle: nil).instantiateInitialViewController()!
            
        case 1:
            return UIStoryboard(name: "FixedScrollDemoVC", bundle: nil).instantiateInitialViewController()!
            
        case 2:
            return UIStoryboard(name: "FullScrollDemoVC", bundle: nil).instantiateInitialViewController()!
            
        default:
            return UIViewController()
        }
    }
    
    open func fluctuateView(_ fluctuateView: FluctuateView, contentTypeByIndex index: Int) -> ContentViewType {
        return .fixed
    }
    
    open func coverView() -> CoverView {
        return CoverView(frame: self.view.frame)
    }
    
    open func noContentView() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.darkGray
        return vc
    }
}

extension FluctuateViewController : FluctuateViewDelegate {
    open func onStateChage(_ state: FluctuateViewState){
        print("\(state)")
    }
}
