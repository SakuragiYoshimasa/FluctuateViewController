//
//  CustomMenuView.swift
//  Demo
//
//  Created by Yoshimasa Sakuragi on 2017/09/26.
//  Copyright © 2017年 Yoshimasa Sakuragi. All rights reserved.
//

import UIKit

class CustomMenuView : MenuView {
    
    var buttons: [UIButton] = []
    
    override func recreateMenuViewByContents(dataSource: FluctuateViewDataSource){
        backgroundColor = UIColor.colorWithHexString(hex: "E8F0FF")
        buttons.forEach({ $0.removeFromSuperview() })
        buttons = []
        
        for i in 0..<dataSource.contentsCount() {
            let button = UIButton(frame: CGRect(x: i * 120 + 100,y: 100, width: 100, height: 60))
            button.backgroundColor = UIColor.colorWithHexString(hex: "000103")
            button.setTitleColor(UIColor.colorWithHexString(hex: "DD2D4A"), for: .normal)
            button.setTitle("\(i)", for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(self.selectContent(_:)), for: .touchUpInside)
            buttons.append(button)
            addSubview(button)
        }
    }
    
    func selectContent(_ sender: UIButton) {
        select(contentIndex: sender.tag)
    }
}
