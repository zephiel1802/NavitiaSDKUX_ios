//
//  UIView+Extension.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

extension UIView {
    
    public func addShadow(color: CGColor = UIColor.black.cgColor,
                          offset: CGSize = CGSize(width: 0, height: 0),
                          opacity: Float = 0.1,
                          radius: CGFloat = 5) {
        layer.masksToBounds = false
        layer.shadowColor = color
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    public func removeShadow() {
        layer.masksToBounds = true
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
    }
    
    public func customActivityIndicatory(startAnimate:Bool? = true) {
        let mainContainer: UIView = UIView(frame: frame)
        mainContainer.center = self.center
        mainContainer.backgroundColor = UIColor.clear
        mainContainer.alpha = 1
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = false
        
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
        viewBackgroundLoading.center = self.center
        viewBackgroundLoading.backgroundColor = UIColor.black
        viewBackgroundLoading.alpha = 0.4
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 5
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
        
        if startAnimate! {
            viewBackgroundLoading.addSubview(activityIndicatorView)
            mainContainer.addSubview(viewBackgroundLoading)
            self.addSubview(mainContainer)
            self.isUserInteractionEnabled = false
            activityIndicatorView.startAnimating()
        } else {
            self.isUserInteractionEnabled = true
            for subview in self.subviews{
                if subview.tag == 789456123 {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
}
