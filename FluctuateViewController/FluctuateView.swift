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
    case fullByFix
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
    open var propaties: FluctuateViewPropaties
    open weak var fullByFixContent: UIView?
    
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
    }
    
    fileprivate func update(_ nextState: FluctuateViewState, content contentIndex: Int?){
        
        if let contIndex = contentIndex {
            
            if nextState != .fullContent {
                content?.show(contIndex)
                transition(prev: state, next: nextState, completion: {
                    self.state = nextState
                    self.delegate?.onStateChage(self.state)
                })()
            } else {
                transition(prev: state, next: .noContent, completion: {
                    self.state = .noContent
                    self.content?.show(contIndex)
                    self.transition(prev: .noContent, next: nextState, completion: {
                        self.state = nextState
                        self.delegate?.onStateChage(self.state)
                    })()
                })()
            }
            
        } else {
            transition(prev: state, next: nextState, completion: {
                self.state = nextState
                self.delegate?.onStateChage(self.state)
            })()
        }
    }
    
    open func updateData(){
        
        clear()
        
        content = ContentView(frame: self.frame)
        content?.clearContents()
        content?.setOffset(0, self.frame.height)
        content?.delegate = self
        content?.registerHeader(header: dataSource!.fullContentHeader())
        content?.registerHeaderByFixed(header: dataSource!.fullContentHeaderByFixed())
        for i in 0..<(dataSource!.contentsCount()) {
            content?.registerContent(content: (dataSource?.fluctuateView(self, contentByIndex: i).view)!,
                                     type: (dataSource?.fluctuateView(self, contentTypeByIndex: i))!,
                                     title: (dataSource?.fluctuateView(self, contentTitle: i))!)
        }
        addSubview(content!)
        
        nocontent = dataSource?.noContentView()
        nocontent?.setOffset(propaties.menuOffsetOnNocontentMode + propaties.menuHeight)
        addSubview(nocontent!)
        
        menu = dataSource?.menuView()
        menu?.setOffset(propaties.menuOffsetOnNocontentMode)
        menu?.delegate = self
        menu?.recreateMenuViewByContents(dataSource: self.dataSource!)
        addSubview(menu!)
        
        cover = dataSource?.coverView()
        cover?.setUnchor(self.frame.height)
        cover?.delegate = self
        addSubview(cover!)
    }
    
    fileprivate func clear(){
        menu?.removeFromSuperview()
        cover?.removeFromSuperview()
        content?.removeFromSuperview()
        nocontent?.removeFromSuperview()
    }
}

extension FluctuateView : FluctuateCoverViewDelegate {
    
    public func coverUp() { update(.noContent, content: nil) }
    
    public func coverDown() {
        switch state {
        case .fullCovered:
            break
        case .noContent:
            update(.fullCovered, content: nil)
            break
        default:
            update(.noContent, content: nil)
            break
        }
    }
}

extension FluctuateView : FluctuateMenuViewDelegate {
    public func selectContent(_ contentIndex: Int) {
        if contentIndex > dataSource!.contentsCount() { return }
        delegate?.onCotentSelected(contentIndex)
        update(dataSource!.fluctuateView(self, contentTypeByIndex: contentIndex) == .fixed ? .fixedContent : .fullContent, content: contentIndex)
    }
}

extension FluctuateView : FluctuateContentViewDelegate {
    public func backToNoContent() {
        update(.noContent, content: nil)
    }
    
    public func transitionToFullFromFixed(fullView: UIView){
        self.fullByFixContent = fullView
        update(.fullByFix, content: nil)
    }
    
    public func backToFixeContentFromFull(contentIndex: Int) {
        update(.fixedContent, content: nil)
    }
}

//Animations
extension FluctuateView {
    
    fileprivate func transition(prev prevState: FluctuateViewState, next nextState: FluctuateViewState, completion: @escaping () -> ()) -> () -> () {
        
        switch nextState {
        case .fullCovered:
            
            return {
                UIView.animate(withDuration: TimeInterval(self.propaties.duration), animations: {
                    self.cover?.setUnchor(self.frame.height)
                }, completion: { _ in
                    completion()
                })
            }
            
        case .noContent:
            
            if prevState == .fullContent {
                
                return {
                    self.frame.origin = CGPoint(x: -self.frame.width, y: 0)
                    self.nocontent?.setOffset(self.propaties.menuOffsetOnNocontentMode + self.propaties.menuHeight)
                    self.menu?.setOffset(self.propaties.menuOffsetOnNocontentMode)
                    self.cover?.setUnchor(self.propaties.menuOffsetOnNocontentMode)
                    self.content?.setOffset(self.frame.width, 0)
                    
                    UIView.animate(withDuration: TimeInterval(self.propaties.duration), delay:0, options: [.curveEaseInOut], animations: {
                        self.frame.origin = CGPoint(x: 0, y: 0)
                        self.content?.setOffset(0 , 0)
                    }, completion: { _ in
                        self.content?.setOffset( 0, self.frame.height)
                        completion()
                    })
                }
                
            }else{
                
                return {
                    let tempState = self.state
                    UIView.animate(withDuration: TimeInterval(self.propaties.duration), delay:0, options: [.curveEaseInOut], animations: {
                        self.cover?.setUnchor(nextState != .fullContent ? self.propaties.menuOffsetOnNocontentMode : self.propaties.fullCoveredOffset)
                        self.menu?.setOffset(self.propaties.menuOffsetOnNocontentMode)
                        self.content?.setOffset(self.frame.height)
                        self.nocontent?.setOffset(self.propaties.menuOffsetOnNocontentMode + self.propaties.menuHeight)
                    }, completion: { _ in
                        if tempState == .fixedContent {
                            self.exchangeSubview(at: 0, withSubviewAt: 1)
                        }
                        completion()
                    })
                }
            }
            
        case .fixedContent:
            
            if prevState != .fixedContent && prevState != .fullByFix {
                
                return {
                    self.exchangeSubview(at: 0, withSubviewAt: 1)
                    UIView.animate(withDuration: TimeInterval(self.propaties.duration), delay:0, options: [.curveEaseInOut], animations: {
                        
                        self.content?.setOffset(self.propaties.menuOffsetOnNocontentMode + self.propaties.menuHeight)
                    }, completion: { _ in
                        
                        UIView.animate(withDuration: TimeInterval(self.propaties.duration), delay:0, options: [.curveEaseInOut], animations: {
                            self.cover?.setUnchor(nextState != .fullContent ? self.propaties.menuOffsetOnFixedContentMode : self.propaties.fullCoveredOffset)
                            self.menu?.setOffset(self.propaties.menuOffsetOnFixedContentMode)
                            self.content?.setOffset(self.propaties.menuOffsetOnFixedContentMode + self.propaties.menuHeight)
                        }, completion: { _ in
                            self.nocontent?.setOffset(self.propaties.menuOffsetOnFixedContentMode + self.propaties.menuHeight)
                            completion()
                        })
                    })
                }
            }
            
            if prevState == .fullByFix {
                
                return {
                    
                    UIView.animate(withDuration: TimeInterval(self.propaties.duration), delay:0, options: [.curveEaseInOut], animations: {
                        
                        self.menu?.setOffset(0 ,self.propaties.menuOffsetOnFixedContentMode)
                        self.cover?.setUnchor(withOffsetX: 0, self.propaties.menuOffsetOnFixedContentMode)
                        self.content?.setOffset(0, self.propaties.menuOffsetOnFixedContentMode + self.propaties.menuHeight)
                        self.nocontent?.setOffset(0, self.propaties.menuOffsetOnFixedContentMode + self.propaties.menuHeight)
                        
                    }, completion: { _ in
                        self.fullByFixContent?.removeFromSuperview()
                        self.content?.showOtherContent()
                        completion()
                    })
                }
            }
            
        case .fullContent:
            
            return {
                
                self.content?.setOffset(0)
                
                UIView.animate(withDuration: TimeInterval(self.propaties.duration), delay:0, options: [.curveEaseInOut], animations: {
                    
                    self.cover?.setUnchor(withOffsetX: -self.frame.width, self.propaties.menuOffsetOnNocontentMode)
                    self.menu?.setOffset(-self.frame.width, self.propaties.menuOffsetOnNocontentMode)
                    self.nocontent?.setOffset(-self.frame.width, self.propaties.menuOffsetOnNocontentMode + self.propaties.menuHeight)
                }, completion: { _ in
                    completion()
                })
            }
        case .fullByFix:
            
            return {
                
                self.addSubview(self.fullByFixContent!)
                self.sendSubview(toBack: self.fullByFixContent!)
                self.fullByFixContent?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                self.content?.hideOtherContent()
                
                UIView.animate(withDuration: TimeInterval(self.propaties.duration), delay:0, options: [.curveEaseInOut], animations: {
                    
                    self.cover?.setUnchor(withOffsetX: -self.frame.width, self.propaties.menuOffsetOnFixedContentMode)
                    self.menu?.setOffset(-self.frame.width, self.propaties.menuOffsetOnFixedContentMode)
                    self.content?.setOffset(-self.frame.width , self.propaties.menuHeight + self.propaties.menuOffsetOnFixedContentMode)
                    self.nocontent?.setOffset(-self.frame.width, self.propaties.menuOffsetOnFixedContentMode + self.propaties.menuHeight)
                    //self.fullByFixContent?.frame.origin = CGPoint(x: 0, y: 0)
                }, completion: { _ in
                    completion()
                })
            }
        }
        
        return {}
    }
}
