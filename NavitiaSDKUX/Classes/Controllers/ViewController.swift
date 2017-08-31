//
//  ViewController.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import UIKit
import Render

open class ViewController: UIViewController {
    var bundle: Bundle = Bundle.main
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        bundle = Bundle.init(for: self.classForCoder)
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: bundle)
        view.backgroundColor = config.colors.lighterGray
        title = String(describing: type(of: self)).replacingOccurrences(of: "ViewController", with: "")
    }
}

/// Copy of ComponentController
/// Just override onLayout method but addComponentToViewControllerHierarchy seems to be redeclared
public extension ComponentController where Self: UIViewController {
    
    /// Adds the component to the view hierarchy.
    public func addComponentToViewControllerHierarchy() {
        component.onLayoutCallback = { [weak self] duration, component, size in
            self?.onLayout(duration: duration, component: component, size: size)
        }
        if let componentView = component as? UIView {
            view.addSubview(componentView)
        }
        configureComponentProps()
    }
    
    /// By default the component is centered in the view controller main view.
    /// Overrid this method for a custom layout.
    public func onLayout(duration: TimeInterval, component: AnyComponentView, size: CGSize) {
        // component.center = view.center
    }
}
