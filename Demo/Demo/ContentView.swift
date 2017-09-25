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



open class ContentView : UIView {
    
    fileprivate lazy var contentCount: Int = 0
    fileprivate lazy var contents: [UIView] = []
    fileprivate lazy var types: [ContentViewType] = []
    fileprivate lazy var contentIndex = 0
    fileprivate lazy var contentSize: CGSize = CGSize(width: 0, height: 0)
    
    fileprivate func reframe(){
        self.frame.size = CGSize(width: contentSize.width * CGFloat(contentCount), height: contentSize.height)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        contentSize = frame.size
        backgroundColor = UIColor.blue
        //addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.test)))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func test(){
        print("taped")
    }
    /*
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view: UIView? = super.hitTest(point, with: event)
        
        if let v = view {
            if v == self { return nil }
        }
        
        return view
    }*/
}

extension ContentView : FluctuateContentView {
    
    final public func setOffset(_ y: CGFloat){
        self.frame.origin = CGPoint(x: frame.minX, y: y)
    }
    
    open func registerContent(content: UIView, type: ContentViewType){
        contents.append(content)
        types.append(type)
        content.frame.origin = CGPoint(x: contentSize.width * CGFloat(contentCount), y: 0)
        //content.isUserInteractionEnabled = true
        //let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.test))
        //gesture.direction = .up
        //content.addGestureRecognizer(gesture)
        //content.frame.size = CGSize(width: self.frame.width, height: content.frame.height)
        addSubview(content)
        contentCount += 1
        reframe()
    }
    
    open func clearContents(){
        contentCount = 0
        contents = []
        types = []
        contentIndex = 0
        reframe()
    }
    
    open func show(_ pageIndex: Int) {
        frame.origin = CGPoint(x: -contentSize.width * CGFloat(pageIndex), y: frame.origin.y)
    }
    
    open func getContentHeight(contentIndex: Int) -> CGFloat {
        return types[contentIndex] == .full ? self.frame.height : 300
    }
}
