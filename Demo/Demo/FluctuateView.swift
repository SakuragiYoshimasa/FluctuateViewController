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
    
    fileprivate lazy var state: FluctuateViewState = .fullCovered
    
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
        state = .fullCovered
        coverUnchor = self.bounds.height
        contentOffset = self.bounds.height + 100
    }
    
    open func update(_ state: FluctuateViewState){
        self.state = state
        switch state {
        case .fullCovered:
            UIView.animate(withDuration: 0.3, animations: {
                self.coverUnchor = self.bounds.height / 3
                self.contentOffset = self.bounds.height + 100
                
                self.cover?.setUnchor(self.coverUnchor)
                self.content?.setOffset(self.contentOffset)
            })
            
            break
        case .noContent:
            UIView.animate(withDuration: 0.3, animations: {
                self.coverUnchor = self.bounds.height / 3
                self.contentOffset = self.bounds.height / 3 + 200
                
                self.cover?.setUnchor(self.coverUnchor)
                self.content?.setOffset(self.contentOffset)
            })
            break
        default:
            break
        }
    }
    
    open func updateData(){
        
        clear()
        
        cover = dataSource?.coverView()
        cover?.setUnchor(coverUnchor)
        cover?.delegate = self
        addSubview(cover!)
        
        content = ContentView(frame: self.frame)
        content?.setOffset(contentOffset)
        content?.registerContent(content: (dataSource?.noContentView().view)!, type: .fixed)
        for i in 0...(dataSource!.contentsCount()) {
            content?.registerContent(content: (dataSource?.fluctuateView(self, contentByIndex: i).view)!,
                                     type: (dataSource?.fluctuateView(self, contentTypeByIndex: i))!)
        }
        addSubview(content!)
        
        //content?.show(1)
    }
    
    open func clear(){
        cover?.removeFromSuperview()
        content?.removeFromSuperview()
    }
}

extension FluctuateView : FluctuateCoverViewDelegate {
    open func coverUp() {
        print("up")
        update(.noContent)
    }
    
    open func coverDown() {
        print("down")
        switch state {
        case .fullCovered:
            break
        case .noContent:
            update(.fullCovered)
            break
        default:
            update(.noContent)
            break
        }
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
    func registerContent(content: UIView, type: ContentViewType)
    func clearContents()
    func show(_ pageIndex: Int)
    func getContentHeight(contentIndex: Int) -> CGFloat
}


public protocol FluctuateViewDelegate : class {
    func onStateChage(_ state: FluctuateViewState)
}

public protocol FluctuateViewDataSource : class {
    func contentsCount() -> Int
    func fluctuateView(_ fluctuateView: FluctuateView, contentTitle index: Int) -> String
    func fluctuateView(_ fluctuateView: FluctuateView, contentByIndex index: Int) -> UIViewController
    func fluctuateView(_ fluctuateView: FluctuateView, contentTypeByIndex index: Int) -> ContentViewType
    func noContentView() -> UIViewController
    func coverView() -> CoverView
}

