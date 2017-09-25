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
    case fullContent
}

public protocol FluctuateCoverViewDelegate : class {
    func coverUp()
    func coverDown()
}

public protocol FluctuateCoverView : class {
    func setUnchor(_ y: CGFloat)
}

public protocol FluctuateMenuViewDelegate : class {
    func selectContent(_ contentIndex: Int)
}

public protocol FluctuateMenuView : class {
    func setOffset(_ y: CGFloat)
}

public protocol FluctuateContentView : class {
    func setOffset(_ y: CGFloat)
    func registerContent(content: UIView, type: ContentViewType)
    func clearContents()
    func show(_ pageIndex: Int)
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
    func menuView() -> MenuView
}

open class FluctuateView : UIView {
    
    open weak var dataSource: FluctuateViewDataSource? {
        didSet {
            guard let _ = dataSource else { return }
            self.updateData()
        }
    }
    
    fileprivate lazy var state: FluctuateViewState = .fullCovered
    open weak var delegate: FluctuateViewDelegate?
    open var cover: CoverView?
    open var menu: MenuView?
    open var content: ContentView?
    open var menuOffset: CGFloat!
    open var menuHeight: CGFloat!
    open var buttons: [UIButton] = []
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    fileprivate func initialize(){
        state = .fullCovered
        menuOffset = self.bounds.height
        menuHeight = 100
    }
    
    fileprivate func update(_ state: FluctuateViewState){
        self.state = state
        
        UIView.animate(withDuration: 0.3, animations: {
            
            switch state {
            case .fullCovered:
                self.menuOffset = self.frame.height
                break
            case .noContent:
                self.menuOffset = 400
                break
            case .fixedContent:
                self.menuOffset = 250
                break
            case .fullContent:
                self.menuOffset = -self.menuOffset
                break
            }
            
            self.cover?.setUnchor(self.menuOffset)
            self.menu?.setOffset(self.menuOffset)
            self.content?.setOffset(self.menuOffset + self.menuHeight)
        })
        delegate?.onStateChage(state)
    }
    
    open func updateData(){
        
        clear()
        
        cover = dataSource?.coverView()
        cover?.setUnchor(menuOffset)
        cover?.delegate = self
        addSubview(cover!)
        
        menu = dataSource?.menuView()
        menu?.setOffset(menuOffset)
        menu?.delegate = self
        addSubview(menu!)
        
        content = ContentView(frame: self.frame)
        content?.clearContents()
        content?.setOffset(menuOffset + menuHeight)
        content?.registerContent(content: (dataSource?.noContentView().view)!, type: .fixed)
        for i in 0..<(dataSource!.contentsCount()) {
            content?.registerContent(content: (dataSource?.fluctuateView(self, contentByIndex: i).view)!,
                                     type: (dataSource?.fluctuateView(self, contentTypeByIndex: i))!)
        }
        addSubview(content!)
    }
    
    fileprivate func clear(){
        buttons.forEach({ $0.removeFromSuperview() })
        buttons = []
        cover?.removeFromSuperview()
        content?.removeFromSuperview()
    }
    
    @objc fileprivate func selectedContent(_ sender: UIButton){
        content?.show(sender.tag)
        let contentType = dataSource!.fluctuateView(self, contentTypeByIndex: sender.tag - 1)
        update(contentType == .fixed ? .fixedContent : .fullContent)
    }
}

extension FluctuateView : FluctuateCoverViewDelegate {
    
    public func coverUp() {
        update(.noContent)
    }
    
    public func coverDown() {
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

extension FluctuateView : FluctuateMenuViewDelegate {
    public func selectContent(_ contentIndex: Int) {
        if contentIndex >= dataSource!.contentsCount() { return }
        content?.show(contentIndex)
        update(dataSource!.fluctuateView(self, contentTypeByIndex: contentIndex) == .fixed ? .fixedContent : .fullContent)
    }
}
