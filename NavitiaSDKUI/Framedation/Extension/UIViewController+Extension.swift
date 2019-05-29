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
            backButton.setTitle("back".localized(), for: .normal)
            backButton.addTarget(self, action: targetSelector, for: .touchUpInside)
            backButton.tintColor = Configuration.Color.main.contrastColor()
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Configuration.Color.main.contrastColor()]
            UINavigationBar.appearance().backgroundColor = Configuration.Color.main
            UIBarButtonItem.appearance().tintColor = Configuration.Color.main.contrastColor()
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
