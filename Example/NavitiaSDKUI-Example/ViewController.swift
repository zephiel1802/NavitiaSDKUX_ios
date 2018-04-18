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
        var params = JourneySolutionViewController.InParameters(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
        params.originLabel = "Chez moi"
        params.destinationLabel = "Au travail"
        params.datetime = Date()
        params.datetime!.addTimeInterval(2000)
        params.datetimeRepresents = .departure
        params.forbiddenUris = ["physical_mode:Bus"]
//        params.firstSectionModes = [.ridesharing]
//        params.lastSectionModes = [.car]
        params.count = 5
        journeyResultsViewController.inParameters = params
        return journeyResultsViewController
    }
    
}


