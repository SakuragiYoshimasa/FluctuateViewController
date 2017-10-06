//
//  NoContentView.swift
//  Demo
//
//  Created by Yoshimasa Sakuragi on 2017/10/05.
//  Copyright © 2017年 Yoshimasa Sakuragi. All rights reserved.
//

import UIKit

open class NoContentView : UIView, FluctuateNoContentView {
    open func setOffset(_ y: CGFloat) {
        self.frame.origin = CGPoint(x: frame.minX, y: y)
    }
}
