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

public protocol FluctuateNoContentView : class {
    func setOffset(_ y: CGFloat)
}

public protocol FluctuateMenuViewDelegate : class {
    func selectContent(_ contentIndex: Int)
}

public protocol FluctuateMenuView : class {
    func recreateMenuViewByContents(dataSource: FluctuateViewDataSource)
}

public protocol FluctuateContentView : class {
    func setOffset(_ x: CGFloat, _ y: CGFloat)
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
    func noContentView() -> NoContentView
    func coverView() -> CoverView
    func menuView() -> MenuView
}

public struct FluctuateViewPropaties {
    public var duration: CGFloat
    public var menuHeight: CGFloat
    public var menuOffsetOnNocontentMode: CGFloat
    public var menuOffsetOnFixedContentMode: CGFloat
    public var fullCoveredOffset: CGFloat
    
    public init(animationDuration: CGFloat,
                menuHeight: CGFloat,
                offsetOnNocontent: CGFloat,
                offsetOnFixedContent: CGFloat,
                fullCoveredOffset: CGFloat ){
        self.duration = animationDuration
        self.menuHeight = menuHeight
        self.menuOffsetOnNocontentMode = offsetOnNocontent
        self.menuOffsetOnFixedContentMode = offsetOnFixedContent
        self.fullCoveredOffset = fullCoveredOffset
    }
    
    public static func defaultPropaties() -> FluctuateViewPropaties {
        return FluctuateViewPropaties(animationDuration: 0.3, menuHeight: 100, offsetOnNocontent: 400, offsetOnFixedContent: 300, fullCoveredOffset: 100)
    }
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
    open var nocontent: NoContentView?
    fileprivate var menuOffset: CGFloat!
    open var propaties: FluctuateViewPropaties
    
    public convenience init(frame: CGRect, propaties: FluctuateViewPropaties) {
        self.init(frame: frame)
        self.propaties = propaties
        initialize()
    }
    
    public override init(frame: CGRect){
        propaties = .defaultPropaties()
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        propaties = .defaultPropaties()
        super.init(coder: aDecoder)
        initialize()
    }
    
    public func setPropaties(propaties: FluctuateViewPropaties){
        self.propaties = propaties
    }
    
    fileprivate func initialize(){
        state = .fullCovered
        menuOffset = self.bounds.height
    }
    
    fileprivate func update(_ nextState: FluctuateViewState){
        
        switch nextState {
        case .fullCovered:
            self.menuOffset = self.frame.height
            UIView.animate(withDuration: TimeInterval(propaties.duration), animations: {
                
                self.cover?.setUnchor(nextState != .fullContent ? self.menuOffset : self.propaties.fullCoveredOffset)
                self.menu?.setOffset(self.menuOffset)
                self.content?.setOffset(self.frame.height)
                self.nocontent?.setOffset(self.frame.height)
            })
            break
        case .noContent:
            
            if self.state == .fullContent {
                
                self.frame.origin = CGPoint(x: -self.frame.width, y: 0)
                self.menuOffset = self.propaties.menuOffsetOnNocontentMode
                
                UIView.animate(withDuration: TimeInterval(propaties.duration), animations: {
                    self.frame.origin = CGPoint(x: 0, y: 0)
                    self.cover?.setUnchor(nextState != .fullContent ? self.menuOffset : self.propaties.fullCoveredOffset)
                    self.menu?.setOffset(self.menuOffset)
                    self.content?.setOffset( self.frame.width, self.propaties.fullCoveredOffset)
                }, completion: { finished in
                    self.content?.setOffset( 0, self.frame.height)
                })
                
            }else{
                
                self.menuOffset = self.propaties.menuOffsetOnNocontentMode
                UIView.animate(withDuration: TimeInterval(propaties.duration), animations: {
                    self.cover?.setUnchor(nextState != .fullContent ? self.menuOffset : self.propaties.fullCoveredOffset)
                    self.menu?.setOffset(self.menuOffset)
                    self.content?.setOffset(self.frame.height)
                    self.nocontent?.setOffset(self.propaties.menuOffsetOnNocontentMode + self.propaties.menuHeight)
                })
            }
            break
            
        case .fixedContent:
            
            if self.state != .fixedContent {
                
                self.menuOffset = self.propaties.menuOffsetOnNocontentMode
                
                UIView.animate(withDuration: TimeInterval(propaties.duration), animations: {
                    
                    self.content?.setOffset(self.menuOffset + self.propaties.menuHeight)
                }, completion: { finished in
                    self.menuOffset = self.propaties.menuOffsetOnFixedContentMode
                    
                    UIView.animate(withDuration: TimeInterval(self.propaties.duration), animations: {
                        self.cover?.setUnchor(nextState != .fullContent ? self.menuOffset : self.propaties.fullCoveredOffset)
                        self.menu?.setOffset(self.menuOffset)
                        self.content?.setOffset(self.menuOffset + self.propaties.menuHeight)
                    })
                })
            }
            break
        case .fullContent:
            
            if self.state != .fixedContent {
                
                self.content?.setOffset(self.frame.width, self.menuOffset + self.propaties.menuHeight)
                self.menuOffset = -self.propaties.menuHeight
                
                UIView.animate(withDuration: TimeInterval(propaties.duration), animations: {
                
                    self.cover?.setUnchor(nextState != .fullContent ? self.menuOffset : self.propaties.fullCoveredOffset)
                    self.menu?.setOffset(self.menuOffset)
                    self.content?.setOffset(self.menuOffset + self.propaties.menuHeight)
                })
                break
                
            } else {
                
                self.content?.setOffset(self.frame.width, self.menuOffset + self.propaties.menuHeight)
                self.menuOffset = -self.propaties.menuHeight
                
                UIView.animate(withDuration: TimeInterval(propaties.duration), animations: {
                    
                    self.cover?.setUnchor(nextState != .fullContent ? self.menuOffset : self.propaties.fullCoveredOffset)
                    self.menu?.setOffset(self.menuOffset)
                    self.content?.setOffset(self.menuOffset + self.propaties.menuHeight)
                })
                break
            }
        }
        
        self.state = nextState
        delegate?.onStateChage(state)
    }
    
    open func updateData(){
        
        clear()
        
        content = ContentView(frame: self.frame)
        content?.clearContents()
        content?.setOffset(0, menuOffset + propaties.menuHeight)
        for i in 0..<(dataSource!.contentsCount()) {
            content?.registerContent(content: (dataSource?.fluctuateView(self, contentByIndex: i).view)!,
                                     type: (dataSource?.fluctuateView(self, contentTypeByIndex: i))!)
        }
        addSubview(content!)
        
        nocontent = dataSource?.noContentView()
        nocontent?.setOffset(menuOffset + propaties.menuHeight)
        addSubview(nocontent!)
        
        menu = dataSource?.menuView()
        menu?.setOffset(menuOffset)
        menu?.delegate = self
        menu?.recreateMenuViewByContents(dataSource: self.dataSource!)
        addSubview(menu!)
        
        cover = dataSource?.coverView()
        cover?.setUnchor(menuOffset)
        cover?.delegate = self
        addSubview(cover!)
    }
    
    fileprivate func clear(){
        menu?.removeFromSuperview()
        cover?.removeFromSuperview()
        content?.removeFromSuperview()
        nocontent?.removeFromSuperview()
    }
    
    @objc fileprivate func selectedContent(_ sender: UIButton){
        content?.show(sender.tag)
        let contentType = dataSource!.fluctuateView(self, contentTypeByIndex: sender.tag)
        update(contentType == .fixed ? .fixedContent : .fullContent)
    }
}

extension FluctuateView : FluctuateCoverViewDelegate {
    
    public func coverUp() { update(.noContent) }
    
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
        if contentIndex > dataSource!.contentsCount() { return }
        content?.show(contentIndex)
        update(dataSource!.fluctuateView(self, contentTypeByIndex: contentIndex) == .fixed ? .fixedContent : .fullContent)
    }
}
