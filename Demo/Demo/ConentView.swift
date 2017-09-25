//
//  ConentView.swift
//  Demo
//
//  Created by Yoshimasa Sakuragi on 2017/09/24.
//  Copyright © 2017年 Yoshimasa Sakuragi. All rights reserved.
//

import UIKit

public enum ContentViewType {
    case fixed
    case fixedScroll
    case fullScroll
}



open class ContentView : UIView {
    
    var type: ContentViewType = .fixed
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.blue
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension ContentView : FluctuateContentView {
    
    final public func setOffset(_ y: CGFloat){
        self.frame.origin = CGPoint(x: frame.minX, y: y)
    }
    
    final public func contentType() -> ContentViewType {
        return .fixed
    }
}


public protocol ContentViewDataSource : class {}

public protocol ContentViewDelegate : class {}
