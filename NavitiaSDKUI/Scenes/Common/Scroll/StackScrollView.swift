//
//  StackScrollView.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol StackScrollViewProtocol {
    
    func addSubview(_ view: UIView, margin: UIEdgeInsets, safeArea: Bool)
    func reloadStack()
}

class StackScrollView: UIScrollView, StackScrollViewProtocol {

    var stackSubviews = [(view: UIView, margin: UIEdgeInsets, safeArea: Bool)]()
    
    func addSubview(_ view: UIView, margin: UIEdgeInsets, safeArea: Bool = true) {
        view.frame.origin.y = getViewOriginY(index: stackSubviews.count, margin: margin)
        view.frame.origin.x = getViewOriginX(margin: margin, safeArea: safeArea)
        view.frame.size.width = getViewSizeWidth(margin: margin, safeArea: safeArea)
        
        stackSubviews.append((view, margin, safeArea))
        addSubview(view)
        
        contentSize.height = getContentSizeHeight()
    }
    
    public func reloadStack() {
        for (index, subview) in stackSubviews.enumerated() {
            subview.view.frame.origin.y = getViewOriginY(index: index, margin: subview.margin)
            subview.view.frame.origin.x = getViewOriginX(margin: subview.margin, safeArea: subview.safeArea)
            subview.view.frame.size.width = getViewSizeWidth(margin: subview.margin, safeArea: subview.safeArea)
        }

        contentSize.height = getContentSizeHeight()
    }
    
    public func selectSubviews<T>(type: T) -> [T] {
        var subviewsSelected = [T]()
        
        for (subview, _, _) in stackSubviews {
            if let subview = subview as? T {
                subviewsSelected.append(subview)
            }
        }
        
        return subviewsSelected
    }
    
    // MARK: Frame
    
    private func getViewOriginY(index: Int, margin: UIEdgeInsets) -> CGFloat {
        if index == 0 {
            return margin.top
        }
        
        if (index > stackSubviews.count - 1) {
            if let lastSubview = stackSubviews.last {
                return lastSubview.view.frame.origin.y + lastSubview.view.frame.height + lastSubview.margin.bottom + margin.top
            }
        }
        
        let previousView = stackSubviews[index - 1]
        
        return previousView.view.frame.origin.y + previousView.view.frame.height + previousView.margin.bottom + margin.top
    }
    
    private func getViewOriginX(margin: UIEdgeInsets, safeArea: Bool) -> CGFloat {
        var margin = margin.left
        
        if #available(iOS 11.0, *), safeArea {
            margin = margin + safeAreaInsets.left
        }
        
        return margin
    }
    
    private func getViewSizeWidth(margin: UIEdgeInsets, safeArea: Bool) -> CGFloat {
        var margin = margin.left + margin.right
        
        if #available(iOS 11.0, *), safeArea {
            margin = margin + safeAreaInsets.left + safeAreaInsets.right
        }
        
        return frame.size.width - margin
    }
    
    private func getContentSizeHeight() -> CGFloat {
        guard let lastSubview = stackSubviews.last else {
            return 0
        }
        
        return lastSubview.view.frame.origin.y + lastSubview.view.frame.height + lastSubview.margin.bottom
    }
}
