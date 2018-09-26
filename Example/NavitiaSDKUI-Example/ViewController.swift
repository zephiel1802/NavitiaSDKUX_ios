//
//  ViewController.swift
//  NavitiaSDKUI-Example
//
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func touch(_ sender: Any) {
        let journeyResultsViewController = getJourneys()
        navigationController?.pushViewController(journeyResultsViewController, animated: true)
    }
    
    private func getJourneys() -> ListJourneysViewController {
        let bundle = Bundle(identifier: "org.cocoapods.NavitiaSDKUI")
        let storyboard = UIStoryboard(name: "Journey", bundle: bundle)
        let journeyResultsViewController = storyboard.instantiateInitialViewController() as! ListJourneysViewController
        var journeysRequest = JourneysRequest(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
        
        journeysRequest.originLabel = "Chez moi"
        journeysRequest.destinationLabel = "Au travail"
        journeysRequest.datetime = Date()
        journeysRequest.datetime!.addTimeInterval(2000)
        journeysRequest.datetimeRepresents = .departure
        journeysRequest.forbiddenUris = ["physical_mode:Bus"]
        journeysRequest.firstSectionModes = [.bss]
        journeysRequest.lastSectionModes = [.car]
        journeysRequest.count = 5
        journeyResultsViewController.journeysRequest = journeysRequest
        
        return journeyResultsViewController
    }
    
}
