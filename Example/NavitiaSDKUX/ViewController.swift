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
        NavitiaSDKUXConfig.setTertiaryColor(color: getUIColorFromHexadecimal(hex: "40958e"))
        NavitiaSDKUXConfig.setRadiusMetrics(value: 0)
        NavitiaSDKUXConfig.setToken(token: "")

        // Set navbar text color
        let textColor = contrastColor(color: NavitiaSDKUXConfig.getTertiaryColor())
        navigationController?.navigationBar.tintColor = textColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: textColor]
        
        // Totally transparent navbar
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = NavitiaSDKUXConfig.getTertiaryColor()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let destination = segue.destination as? JourneySolutionsController {
            destination.setProps(originId: "admin:fr:77058", destinationId: "stop_area:OIF:SA:8738221")
        }
    }
}
