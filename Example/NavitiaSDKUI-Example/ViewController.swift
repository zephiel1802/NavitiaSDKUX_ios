//
//  ViewController.swift
//  NavitiaSDKUI-Example
//
//  Created by Flavien Sicard on 23/03/2018.
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit
import NavitiaSDKUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func touch(_ sender: Any) {
        let bundle = Bundle(identifier: "org.cocoapods.NavitiaSDKUI")
        let storyboard = UIStoryboard(name: "Journey", bundle: bundle)
        let journeyResultsViewController = storyboard.instantiateInitialViewController() as! JourneySolutionViewController
//        self.present(UINavigationController(rootViewController: journeyResultsViewController), animated: true, completion: nil)
        navigationController?.pushViewController(journeyResultsViewController, animated: true)
    }
    
}


