//
//  UIViewController+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension UIViewController {
        
    func addBackButton(targetSelector: Selector) {
        if isRootViewController() {
            let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            backButton.setImage(UIImage(named: "back-icon", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
            backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -32, bottom: 0, right: 0)
            backButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 0)
            backButton.setTitle("back".localized(withComment: "Back", bundle: NavitiaSDKUI.shared.bundle), for: .normal)
            backButton.addTarget(self, action: targetSelector, for: .touchUpInside)
            backButton.tintColor = Configuration.Color.main.contrastColor()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
            
            UINavigationBar.appearance().backgroundColor = Configuration.Color.main
            UIBarButtonItem.appearance().tintColor = Configuration.Color.main.contrastColor()
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Configuration.Color.main.contrastColor()]
        }
    }
    
    func isRootViewController() -> Bool {
        if self.navigationController != nil && self.navigationController!.viewControllers.count > 1 {
            return false
        }
        
        return true
    }
    
    func addChildView(childViewController: UIViewController) {
        addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParentViewController: self)
    }
    
}
