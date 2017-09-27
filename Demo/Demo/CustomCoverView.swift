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
        
        let label = UILabel(frame: CGRect(x: frame.width / 2 - 100, y: frame.height - 100 , width: 200, height: 50))
        label.text = "CustomCover"
        label.textColor = UIColor.black
        label.textAlignment = .center
        addSubview(label)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
