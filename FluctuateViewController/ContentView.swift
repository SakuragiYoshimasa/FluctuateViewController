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

open class ContentView : UIView, FluctuateContentView, FluctuateContentHeaderDelegate, FullContentHeaderByFixedDelegate {

    fileprivate lazy var contentCount: Int = 0
    fileprivate lazy var contentIndex = 0
    fileprivate lazy var contents: [UIView] = []
    fileprivate lazy var types: [ContentViewType] = []
    fileprivate lazy var titles: [String] = []
    fileprivate lazy var contentSize: CGSize = CGSize(width: 0, height: 0)
    fileprivate lazy var isFullByFix: Bool = false
    fileprivate var header: (UIView & FluctuateFullContentHeader)?
    open var headerByFixed: (UIView & FullContentHeaderByFixed)?
    open weak var delegate: FluctuateContentViewDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        contentSize = frame.size
    }
 
    fileprivate func reframe(){
        self.frame.size = CGSize(width: contentSize.width * CGFloat(contentCount), height: contentSize.height)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //FluctuateContentView
    
    final public func setOffset(_ x: CGFloat ,_ y: CGFloat){
        self.frame.origin = CGPoint(x: x - contentSize.width * CGFloat(contentIndex), y: y)
    }
    
    final public func setOffset(_ y: CGFloat){
        self.frame.origin = CGPoint(x: -contentSize.width * CGFloat(contentIndex), y: y)
    }
    
    final public func registerContent(content: UIView, type: ContentViewType, title: String){
        contents.append(content)
        titles.append(title)
        types.append(type)
        content.frame.origin = CGPoint(x: contentSize.width * CGFloat(contentCount), y: type == .fixed ? 0 : (header?.frame.height)!)
        addSubview(content)
        contentCount += 1
        reframe()
    }
    
    final public func registerHeader(header contentHeader: UIView & FluctuateFullContentHeader){
        self.header = contentHeader
        self.header?.delegate = self
    }
    
    open func registerHeaderByFixed(header fullbyfixHeader: UIView & FullContentHeaderByFixed){
        self.headerByFixed = fullbyfixHeader
        self.headerByFixed?.delegate = self
    }
    
    final public func clearContents(){
        contentCount = 0
        contentIndex = 0
        contents = []
        titles = []
        types = []
        reframe()
    }
    
    final public func show(_ pageIndex: Int) {
        if pageIndex >= contentCount { return }
        frame.origin = CGPoint(x: -contentSize.width * CGFloat(pageIndex), y: frame.origin.y)
        contentIndex = pageIndex
        if types[contentIndex] == .full {
            addSubview(self.header!)
            self.header?.frame.origin = CGPoint(x: contentSize.width * CGFloat(pageIndex), y: 0)
            self.header?.setContentTitle(title: titles[contentIndex])
        } else {
            self.header?.removeFromSuperview()
        }
    }
    
    //Header Delegate
    final public func backButtonTouched(){
        delegate?.backToNoContent()
    }
    
    //Header By fixed
    final public func backButtonTouchedByFixed(){
        delegate?.backToFixeContentFromFull(contentIndex: contentIndex)
    }
}
