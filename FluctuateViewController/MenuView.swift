//
//  MenuView.swift
//  Demo
//
//  Created by Yoshimasa Sakuragi on 2017/09/26.
//  Copyright © 2017年 Yoshimasa Sakuragi. All rights reserved.
//

import UIKit

open class MenuView : UIView, FluctuateMenuView {
    
    open var delegate: FluctuateMenuViewDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //FluctuateMenuView
    public final func select(contentIndex: Int){ delegate?.selectContent(contentIndex) }
    final public func setOffset(_ y: CGFloat){
        self.frame.origin = CGPoint(x: frame.minX, y: y)
    }
    open func recreateMenuViewByContents(dataSource: FluctuateViewDataSource){}
}
