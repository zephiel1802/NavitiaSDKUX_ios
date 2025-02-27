//
//  UIViewController+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func setTitle(title: String) {
        if let navigationController = navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationItem.title = title
                
                if let parent = self.parent, !parent.isKind(of: UINavigationController.self) {
                    parent.title = title
                }
            } else {
                navigationController.navigationBar.topItem?.title = title
            }
            
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Configuration.Color.main.contrastColor()]
            navigationController.navigationBar.tintColor = Configuration.Color.main.contrastColor()
        } else {
            self.title = title
        }
        
        UINavigationBar.appearance().backgroundColor = Configuration.Color.main
        UIBarButtonItem.appearance().tintColor = Configuration.Color.main.contrastColor()
    }
    
    func addBackButton(targetSelector: Selector) {
        if isRootViewController() {
            let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            
            backButton.setImage("back-icon".getIcon(), for: .normal)
            backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -32, bottom: 0, right: 0)
            backButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 0)
            backButton.setTitle("back".localized(), for: .normal)
            backButton.addTarget(self, action: targetSelector, for: .touchUpInside)
            backButton.tintColor = Configuration.Color.main.contrastColor()
            backButton.setTitleColor(backButton.tintColor, for: .normal)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
    }
    
    func isRootViewController() -> Bool {
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            return false
        }
        
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
