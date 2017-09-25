//
//  CustomCoverView.swift
//  Demo
//
//  Created by Yoshimasa Sakuragi on 2017/09/26.
//  Copyright © 2017年 Yoshimasa Sakuragi. All rights reserved.
//

import UIKit

class CustomCoverView : CoverView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.cyan
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
