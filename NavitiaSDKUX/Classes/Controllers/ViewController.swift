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
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundleForClass: self.classForCoder)
        view.backgroundColor = config.colors.tertiary
        title = String(describing: type(of: self)).replacingOccurrences(of: "ViewController", with: "")
    }
}
