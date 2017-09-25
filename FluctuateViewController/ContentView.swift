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
    case full
}

open class ContentView : UIView, FluctuateContentView {
    
    fileprivate lazy var contentCount: Int = 0
    fileprivate lazy var contentIndex = 0
    fileprivate lazy var contents: [UIView] = []
    fileprivate lazy var types: [ContentViewType] = []
    fileprivate lazy var contentSize: CGSize = CGSize(width: 0, height: 0)
    
    fileprivate func reframe(){
        self.frame.size = CGSize(width: contentSize.width * CGFloat(contentCount), height: contentSize.height)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        contentSize = frame.size
        backgroundColor = UIColor.blue
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //FluctuateContentView
    
    final public func setOffset(_ y: CGFloat){
        self.frame.origin = CGPoint(x: frame.minX, y: y)
    }
    
    open func registerContent(content: UIView, type: ContentViewType){
        contents.append(content)
        types.append(type)
        content.frame.origin = CGPoint(x: contentSize.width * CGFloat(contentCount), y: 0)
        addSubview(content)
        contentCount += 1
        reframe()
    }
    
    public func clearContents(){
        contentCount = 0
        contentIndex = 0
        contents = []
        types = []
        reframe()
    }
    
    public func show(_ pageIndex: Int) {
        if pageIndex >= contentCount { return }
        frame.origin = CGPoint(x: -contentSize.width * CGFloat(pageIndex), y: frame.origin.y)
    }
}
