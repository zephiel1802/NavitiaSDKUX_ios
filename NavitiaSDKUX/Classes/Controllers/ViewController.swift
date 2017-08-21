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
        view.backgroundColor = config.colors.tertiary
        title = String(describing: type(of: self)).replacingOccurrences(of: "ViewController", with: "")
    }
}
