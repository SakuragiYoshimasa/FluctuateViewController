//
//  SampleFullContentHeaderByFixed.swift
//  Demo
//
//  Created by Yoshimasa Sakuragi on 2017/10/11.
//  Copyright © 2017年 Yoshimasa Sakuragi. All rights reserved.
//

import UIKit

open class SampleFullContentHeaderByFixed : UIView, FullContentHeaderByFixed {
    public var delegate: FullContentHeaderByFixedDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let button = UIButton(frame: frame)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(self.touched), for: .touchUpInside)
        addSubview(button)
    }
    
    @objc private func touched(){
        delegate?.backButtonTouchedByFixed()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setContentTitle(title: String){
        print(title)
    }
}

