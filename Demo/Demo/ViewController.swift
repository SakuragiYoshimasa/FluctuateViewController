//
//  ViewController.swift
//  Demo
//
//  Created by Yoshimasa Sakuragi on 2017/09/26.
//  Copyright © 2017年 Yoshimasa Sakuragi. All rights reserved.
//

import UIKit

class ViewController : FluctuateViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting propaties
        fluctuateView.setPropaties(propaties: FluctuateViewPropaties(animationDuration: 0.4, menuHeight: 200, offsetOnNocontent: 400, offsetOnFixedContent: 60, fullCoveredOffset: 60))
        self.view.backgroundColor = UIColor.colorWithHexString(hex: "000103")
    }
    
    // FluctuateViewDataSource
    override func contentsCount() -> Int { return 3 }
    
    override func fluctuateView(_ fluctuateView: FluctuateView, contentTitle index: Int) -> String {
        return "\(index)"
    }
    
    override func fluctuateView(_ fluctuateView: FluctuateView, contentByIndex index: Int) -> UIViewController {
        
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
    
    override func fluctuateView(_ fluctuateView: FluctuateView, contentTypeByIndex index: Int) -> ContentViewType {
        return index < 2 ? .fixed : .full
    }
    
    override func coverView() -> CoverView {
        return CustomCoverView(frame: self.view.frame)
    }
    
    override func menuView() -> MenuView {
        return CustomMenuView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
    }
    
    override func noContentView() -> NoContentView {
        let nocontent = NoContentView(frame: self.view.frame)
        nocontent.backgroundColor = UIColor.brown
        return nocontent
    }
    // FluctuateViewDelegate
    override func onStateChage(_ state: FluctuateViewState){
        print("\(state)")
    }
}

