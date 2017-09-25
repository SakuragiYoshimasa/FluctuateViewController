//
//  CoverView.swift
//  Demo
//
//  Created by Yoshimasa Sakuragi on 2017/09/24.
//  Copyright © 2017年 Yoshimasa Sakuragi. All rights reserved.
//

import UIKit



open class CoverView : UIView {
    
    open weak var delegate: FluctuateCoverViewDelegate?
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        
        let swipeUpRecognizer = UISwipeGestureRecognizer(target:self, action:#selector(self.swipe(sender:)))
        swipeUpRecognizer.direction = .up
        let swipeDownRecognizer = UISwipeGestureRecognizer(target:self, action:#selector(self.swipe(sender:)))
        swipeDownRecognizer.direction = .down
        
        addGestureRecognizer(swipeUpRecognizer)
        addGestureRecognizer(swipeDownRecognizer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func swipe(sender:UISwipeGestureRecognizer) {
        
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
}

extension CoverView : FluctuateCoverView {
    final public func setUnchor(_ y: CGFloat) {
        self.frame.origin = CGPoint(x: frame.minX, y: y - frame.size.height)
    }
}


