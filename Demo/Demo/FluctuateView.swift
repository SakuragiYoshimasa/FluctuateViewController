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
        coverUnchor = self.bounds.height
        contentOffset = self.bounds.height + 100
    }
    
    fileprivate func update(_ state: FluctuateViewState){
        self.state = state
        switch state {
        case .fullCovered:
            UIView.animate(withDuration: 0.3, animations: {
                self.coverUnchor = self.bounds.height
                self.contentOffset = self.bounds.height + 200
                
                self.cover?.setUnchor(self.coverUnchor)
                self.content?.setOffset(self.contentOffset)
                
                for i in 0..<(self.dataSource!.contentsCount()) {
                    self.buttons[i].frame = CGRect(x: 50 + i * 50, y: Int(50 + self.coverUnchor), width: 60, height: 60)
                }
            })
            
            break
        case .noContent:
            UIView.animate(withDuration: 0.3, animations: {
                self.coverUnchor = self.bounds.height / 4
                self.contentOffset = self.bounds.height / 4 + 200
                
                self.cover?.setUnchor(self.coverUnchor)
                self.content?.setOffset(self.contentOffset)
                self.content?.show(0)
                
                for i in 0..<(self.dataSource!.contentsCount()) {
                    self.buttons[i].frame = CGRect(x: 50 + i * 50, y: Int(50 + self.coverUnchor), width: 60, height: 60)
                }
            })
            break
        case .fixedContent:
            UIView.animate(withDuration: 0.3, animations: {
                self.coverUnchor = self.bounds.height / 8
                self.contentOffset = self.bounds.height / 8 + 200
                
                self.cover?.setUnchor(self.coverUnchor)
                self.content?.setOffset(self.contentOffset)
                
                for i in 0..<(self.dataSource!.contentsCount()) {
                    self.buttons[i].frame = CGRect(x: 50 + i * 50, y: Int(50 + self.coverUnchor), width: 60, height: 60)
                }
            })
            break
            
        case .fullContent:
            UIView.animate(withDuration: 0.3, animations: {
                self.coverUnchor = 50
                self.contentOffset = 50
                
                self.cover?.setUnchor(self.coverUnchor)
                self.content?.setOffset(self.contentOffset)
                
                for i in 0..<(self.dataSource!.contentsCount()) {
                    self.buttons[i].frame = CGRect(x: 50 + i * 50, y: Int(self.coverUnchor - 120), width: 60, height: 60)
                }
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
        content?.clearContents()
        content?.setOffset(contentOffset)
        content?.registerContent(content: (dataSource?.noContentView().view)!, type: .fixed)
        for i in 0..<(dataSource!.contentsCount()) {
            content?.registerContent(content: (dataSource?.fluctuateView(self, contentByIndex: i).view)!,
                                     type: (dataSource?.fluctuateView(self, contentTypeByIndex: i))!)
        }
        
        addSubview(content!)
        makeButtons()
    }
    
    fileprivate func clear(){
        buttons.forEach({ $0.removeFromSuperview() })
        buttons = []
        cover?.removeFromSuperview()
        content?.removeFromSuperview()
    }
    
    fileprivate func makeButtons(){
        
        for i in 0..<(dataSource!.contentsCount()) {
            let button = UIButton(frame: CGRect(x: 50 + i * 50, y: Int(50 + coverUnchor), width: 60, height: 60))
            button.tag = i + 1
            button.backgroundColor = UIColor.cyan
            button.setTitle("\(i)", for: .normal)
            buttons.append(button)
            button.addTarget(self, action: #selector(self.selectedContent(_:)), for: .touchUpInside)
            addSubview(button)
        }
    }
    
    @objc fileprivate func selectedContent(_ sender: UIButton){
        content?.show(sender.tag)
        let contentType = dataSource!.fluctuateView(self, contentTypeByIndex: sender.tag - 1)
        update(contentType == .fixed ? .fixedContent : .fullContent)
    }
}

extension FluctuateView : FluctuateCoverViewDelegate {
    
    public func coverUp() {
        print("up")
        update(.noContent)
    }
    
    public func coverDown() {
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

