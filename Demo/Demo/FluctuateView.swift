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
    
    open var dataSource: FluctuateViewDataSource? {
        didSet {
            guard let _ = dataSource else { return }
            self.update()
        }
    }

    open var delegate: FluctuateViewDelegate?
    open var cover: CoverView?
    open var content: ContentView?
    
    open weak var controlPoint : UIButton?
    private lazy var state: FluctuateViewState = .fullCovered
    
    //FluctuateConetntViewで選択する
    //FluctuateContentStylesでスタイル
    //CoverViewが上
    //
    //Have a controll point
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    open func initialize(){}
    
    open func update(){
        clear()
        
        cover = dataSource?.coverView()
        cover?.setUnchor(self.bounds.height / 2.0)
        addSubview(cover!)
        
        content = dataSource?.contentView()
        content?.setOffset(self.bounds.height / 1.5)
        addSubview(content!)
    }
    
    open func clear(){
        cover?.removeFromSuperview()
        content?.removeFromSuperview()
    }
    
    open func stateChange(_ state: FluctuateViewState){}
    
}

//extension FluctuateView : CoverViewDelegate {}

//extension FluctuateView : ContentViewDelegate {}

public protocol FluctuateCoverView {
    func setUnchor(_ y: CGFloat)
}

public protocol FluctuateContentView {
    func setOffset(_ y: CGFloat)
    func contentType() -> ContentViewType
}


public protocol FluctuateViewDelegate : class {
    func onStateChage(_ state: FluctuateViewState)
}

public protocol FluctuateViewDataSource : class {
    func contentsCount() -> Int
    func fluctuateView(_ fluctuateView: FluctuateView, contentsTitle index: Int) -> String
    func fluctuateView(_ fluctuateView: FluctuateView, viewController index: Int) -> UIViewController
    func coverView() -> CoverView
    func contentView() -> ContentView
}

