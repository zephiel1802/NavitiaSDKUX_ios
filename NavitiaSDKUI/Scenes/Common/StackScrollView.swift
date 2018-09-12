//
//  StackScrollView.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 07/09/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol StackScrollViewProtocol {
    
    func addViewInScroll(view: UIView, margin: UIEdgeInsets)
    func updateScrollView()
}

//extension UIScrollView {
//
//    var scrollSubviews = [(view: UIView, margin: UIEdgeInsets)]()
//
//    func addViewInScroll(view: UIView, margin: UIEdgeInsets) {
//        if scrollSubviews.isEmpty {
//            view.frame.origin.y = margin.top
//        } else {
//            if let viewBefore = scrollSubviews.last {
//                view.frame.origin.y = viewBefore.view.frame.origin.y + viewBefore.view.frame.height + viewBefore.margin.bottom + margin.top
//            }
//        }
//        view.frame.size.width = self.frame.size.width - (margin.left + margin.right)
//        view.frame.origin.x = margin.left
//
//        scrollSubviews.append((view, margin))
//
//        if let last = scrollSubviews.last {
//            self.contentSize.height = last.view.frame.origin.y + last.view.frame.height + last.margin.bottom
//        }
//        self.addSubview(view)
//    }
//
//    func updateScrollView() {
//        for (index, view) in scrollSubviews.enumerated() {
//            if index == 0 {
//                view.view.frame.origin.y = 0 + view.margin.top
//            } else {
//                let beforeView = scrollSubviews[index - 1]
//                view.view.frame.origin.y = beforeView.view.frame.origin.y + beforeView.view.frame.height + beforeView.margin.bottom + view.margin.top
//            }
//            view.view.frame.size.width = scrollView.frame.size.width - (view.margin.left + view.margin.right)
//            view.view.frame.origin.x = view.margin.left
//        }
//
//        if let last = scrollSubviews.last {
//            self.contentSize.height = last.view.frame.origin.y + last.view.frame.height + last.margin.bottom
//        }
//    }
//}
