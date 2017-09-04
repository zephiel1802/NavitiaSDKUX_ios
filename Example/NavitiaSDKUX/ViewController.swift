//
//  ViewController.swift
//  NavitiaSDKUX
//
//  Created by ooga on 08/18/2017.
//  Copyright (c) 2017 ooga. All rights reserved.
//

import UIKit
import NavitiaSDKUX

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Override Navitia SDK UX Config
        NavitiaSDKUXConfig.colors.tertiary = getUIColorFromHexadecimal(hex: "37ab2e")
        NavitiaSDKUXConfig.metrics.radius = 0
        
        // Set navbar text color
        let textColor = contrastColor(color: NavitiaSDKUXConfig.colors.tertiary)
        navigationController?.navigationBar.tintColor = textColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: textColor]
        
        // Totally transparent navbar
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = NavitiaSDKUXConfig.colors.tertiary
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let destination = segue.destination as? JourneySolutionsController {
            destination.setProps(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
        }
    }
}

