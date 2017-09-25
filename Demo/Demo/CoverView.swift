//
//  CoverView.swift
//  Demo
//
//  Created by Yoshimasa Sakuragi on 2017/09/24.
//  Copyright © 2017年 Yoshimasa Sakuragi. All rights reserved.
//

import UIKit



open class CoverView : UIView{

    public override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension CoverView : FluctuateCoverView {
    final public func setUnchor(_ y: CGFloat) {
        self.frame.origin = CGPoint(x: frame.minX, y: y - frame.size.height)
    }
}


