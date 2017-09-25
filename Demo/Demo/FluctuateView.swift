//
//  FluctuateView.swift
//  Demo
//
//  Created by Yoshimasa Sakuragi on 2017/09/24.
//  Copyright © 2017年 Yoshimasa Sakuragi. All rights reserved.
//

import UIKit

public enum FluctuateViewState {
    case fullCovered
    case noContent
    case fixedContent
    case scrollContent
    case fullScrollContent
}

public struct FluctuateViewStyles {}

open class FluctuateView : UIView {
    
    open weak var dataSource: FluctuateViewDataSource? {
        didSet {
            guard let _ = dataSource else { return }
            self.updateData()
        }
    }

    open weak var delegate: FluctuateViewDelegate?
    open var cover: CoverView?
    open var content: ContentView?
    
    private lazy var state: FluctuateViewState = .fullCovered
    
    open var coverUnchor: CGFloat!
    open var contentOffset: CGFloat!
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    open func initialize(){
        
        coverUnchor = self.bounds.height / 2
        contentOffset = self.bounds.height / 1.5
    }
    
    open func update(){}
    
    open func updateData(){
        
        clear()
        
        cover = dataSource?.coverView()
        cover?.setUnchor(coverUnchor)
        cover?.delegate = self
        addSubview(cover!)
        
        content = ContentView(frame: self.frame)
        content?.setOffset(contentOffset)
        addSubview(content!)
    }
    
    open func clear(){
        cover?.removeFromSuperview()
        content?.removeFromSuperview()
    }
    
    open func stateChange(_ state: FluctuateViewState){}
    
}

extension FluctuateView : FluctuateCoverViewDelegate {
    open func coverUp() {
        print("up")
    }
    
    open func coverDown() {
        print("down")
    }
}

public protocol FluctuateCoverViewDelegate : class {
    func coverUp()
    func coverDown()
}

public protocol FluctuateCoverView : class {
    func setUnchor(_ y: CGFloat)
}

public protocol FluctuateContentView : class {
    func setOffset(_ y: CGFloat)
    func contentType() -> ContentViewType
}


public protocol FluctuateViewDelegate : class {
    func onStateChage(_ state: FluctuateViewState)
}

public protocol FluctuateViewDataSource : class {
    func contentsCount() -> Int
    func fluctuateView(_ fluctuateView: FluctuateView, contentTitle index: Int) -> String
    func fluctuateView(_ fluctuateView: FluctuateView, contentByIndex index: Int) -> UIViewController
    func coverView() -> CoverView
}

