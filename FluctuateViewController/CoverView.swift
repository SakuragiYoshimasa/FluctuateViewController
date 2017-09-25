//
//  CoverView.swift
//  Demo
//
//  Created by Yoshimasa Sakuragi on 2017/09/24.
//  Copyright © 2017年 Yoshimasa Sakuragi. All rights reserved.
//

import UIKit

open class CoverView : UIView, FluctuateCoverView {
    
    open weak var delegate: FluctuateCoverViewDelegate?
    
    public override init(frame: CGRect){
        super.init(frame: frame)
    
        let swipeUpRecognizer = UISwipeGestureRecognizer(target:self, action:#selector(self.swipe(sender:)))
        let swipeDownRecognizer = UISwipeGestureRecognizer(target:self, action:#selector(self.swipe(sender:)))
        swipeUpRecognizer.direction = .up
        swipeDownRecognizer.direction = .down
        addGestureRecognizer(swipeUpRecognizer)
        addGestureRecognizer(swipeDownRecognizer)
    }
    
    @objc fileprivate func swipe(sender:UISwipeGestureRecognizer) {
        
        switch(sender.direction){
        case UISwipeGestureRecognizerDirection.up:
            delegate?.coverUp()
            break
        case UISwipeGestureRecognizerDirection.down:
            delegate?.coverDown()
            break
        default:
            break
        }
    }
    
    //FluctuateCoverView
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    final public func setUnchor(_ y: CGFloat) {
        self.frame.origin = CGPoint(x: frame.minX, y: y - frame.size.height)
    }
}
