//
//  ViewController.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import UIKit

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

        if (navigationController?.viewControllers.first === self && presentingViewController !== nil) {
            let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            let backImage = UIImage(named: "ios_back", in: bundle, compatibleWith: nil)
            backButton.setImage(backImage, for: .normal)
            backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -32, bottom: 0, right: 0)
            backButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 0)
            backButton.setTitle("Back", for: .normal)
            backButton.addTarget(self, action: #selector(closeRootController), for: .touchUpInside)
            let backBarButton = UIBarButtonItem(customView: backButton)

            let textColor = navigationController?.navigationBar.tintColor ?? contrastColor(color: NavitiaSDKUXConfig.getTertiaryColor())
            backButton.tintColor = textColor
            backButton.setTitleColor(textColor, for: .normal)

            self.navigationItem.leftBarButtonItem = backBarButton
        }
    }

    func closeRootController() {
        self.dismiss(animated: true, completion: nil)
    }
}

/// Copy of ComponentController
/// Just override onLayout method but addComponentToViewControllerHierarchy seems to be redeclared
public extension ComponentController where Self: UIViewController {

    /// Adds the component to the view hierarchy.
    public func addComponentToViewControllerHierarchyExtended() {
        component.onLayoutCallback = { [weak self] duration, component, size in
            self?.onLayout(duration: duration, component: component, size: size)
        }
        if let componentView = component as? UIView {
            view.addSubview(componentView)
        }
        configureComponentProps()
    }
}
