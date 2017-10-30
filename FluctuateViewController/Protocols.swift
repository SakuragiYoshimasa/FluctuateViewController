//
//  Protocols.swift
//  Demo
//
//  Created by Yoshimasa Sakuragi on 2017/10/08.
//  Copyright © 2017年 Yoshimasa Sakuragi. All rights reserved.
//

import UIKit

public protocol FluctuateCoverViewDelegate : class {
    func coverUp()
    func coverDown()
}

public protocol FluctuateCoverView : class {
    func setUnchor(_ y: CGFloat)
    func setUnchor(withOffsetX x: CGFloat, _ y: CGFloat)
}

public protocol FluctuateNoContentView : class {
    func setOffset(_ x: CGFloat, _ y: CGFloat)
    func setOffset(_ y: CGFloat)
}

public protocol FluctuateMenuViewDelegate : class {
    func selectContent(_ contentIndex: Int)
}

public protocol FluctuateMenuView : class {
    func setOffset(_ x: CGFloat, _ y: CGFloat)
    func recreateMenuViewByContents(dataSource: FluctuateViewDataSource)
}

public protocol FluctuateContentView : class {
    func setOffset(_ x: CGFloat, _ y: CGFloat)
    func setOffset(_ y: CGFloat)
    func registerContent(content: UIView, type: ContentViewType, title: String)
    func registerHeader(header: UIView & FluctuateFullContentHeader)
    func registerHeaderByFixed(header fullbyfixHeader: UIView & FullContentHeaderByFixed)
    func clearContents()
    func resetTitles(titles: [String])
    func show(_ pageIndex: Int)
}

public protocol FluctuateFullContentHeader : class {
    var delegate: FluctuateContentHeaderDelegate? { get set }
    func setContentTitle(title: String)
}

public protocol FullContentHeaderByFixed : class {
    var delegate: FullContentHeaderByFixedDelegate? { get set }
    func setContentTitle(title: String)
}

public protocol FluctuateContentHeaderDelegate : class {
    func backButtonTouched()
}

public protocol FullContentHeaderByFixedDelegate : class {
    func backButtonTouchedByFixed()
}

public protocol FluctuateContentViewDelegate : class {
    func backToNoContent()
    func transitionToFullFromFixed(fullView: UIView)
    func backToFixeContentFromFull(contentIndex: Int)
}

public protocol FluctuateViewDelegate : class {
    func onStateChage(_ state: FluctuateViewState)
    func onCotentSelected(_ contentIndex: Int)
}

public protocol FluctuateViewDataSource : class {
    func contentsCount() -> Int
    func fluctuateView(_ fluctuateView: FluctuateView, contentTitle index: Int) -> String
    func fluctuateView(_ fluctuateView: FluctuateView, contentByIndex index: Int) -> UIViewController
    func fluctuateView(_ fluctuateView: FluctuateView, contentTypeByIndex index: Int) -> ContentViewType
    func fullContentHeader() -> UIView & FluctuateFullContentHeader
    func fullContentHeaderByFixed() -> UIView & FullContentHeaderByFixed
    func noContentView() -> NoContentView
    func coverView() -> CoverView
    func menuView() -> MenuView
}
