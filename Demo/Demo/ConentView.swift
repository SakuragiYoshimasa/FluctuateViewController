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



open class ContentView : UIView, FluctuateContentView {
    
    var type: ContentViewType = .fixed
    
}



public protocol ContentViewDataSource : class {}

public protocol ContentViewDelegate : class {}
