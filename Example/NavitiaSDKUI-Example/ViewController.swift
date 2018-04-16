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

    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func touch(_ sender: Any) {
        let journeyResultsViewController = getJourneys()
        navigationController?.pushViewController(journeyResultsViewController, animated: true)
    }
    
    
    private func getJourneys() -> JourneySolutionViewController {
        let bundle = Bundle(identifier: "org.cocoapods.NavitiaSDKUI")
        let storyboard = UIStoryboard(name: "Journey", bundle: bundle)
        let journeyResultsViewController = storyboard.instantiateInitialViewController() as! JourneySolutionViewController
        journeyResultsViewController.inParameters = JourneySolutionViewController.InParameters(originId: "2.377092;48.846789",
                                                                                               destinationId: "2.294685;48.884075")
        journeyResultsViewController.inParameters.originLabel = "Chez moi"
        journeyResultsViewController.inParameters.destinationLabel = "Au travail"
        journeyResultsViewController.inParameters.datetime = Date()
//        journeyResultsViewController.inParameters.datetime!.addTimeInterval(2000)
        journeyResultsViewController.inParameters.datetimeRepresents = .departure
//        journeyResultsViewController.inParameters.forbiddenUris = ["physical_mode:Bus"]
        journeyResultsViewController.inParameters.firstSectionModes = [.bss]
        journeyResultsViewController.inParameters.lastSectionModes = [.car]
        journeyResultsViewController.inParameters.count = 5
        return journeyResultsViewController
    }
    
}


