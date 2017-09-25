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
    open func contentsCount() -> Int { return 1}
    open func fluctuateView(_ fluctuateView: FluctuateView, contentsTitle index: Int) -> String {
        return ""
    }
    open func fluctuateView(_ fluctuateView: FluctuateView, viewController index: Int) -> UIViewController {
        return UIViewController()
    }
    
    open func coverView() -> CoverView {
        return CoverView(frame: self.view.frame)
    }
    
    open func contentView() -> ContentView {
        return ContentView(frame: self.view.frame)
    }
}

extension FluctuateViewController : FluctuateViewDelegate {
    open func onStateChage(_ state: FluctuateViewState){}
}
