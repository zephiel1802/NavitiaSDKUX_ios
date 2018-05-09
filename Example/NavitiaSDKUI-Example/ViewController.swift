//
//  ViewController.swift
//  NavitiaSDKUI-Example
//
//  Copyright © 2018 kisio. All rights reserved.
//
import UIKit
import NavitiaSDKUI

class ViewController: UIViewController, BookShopViewControllerDelegate {
    
    var bookShopViewController: BookShopViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Journey
    @IBAction func onSDKJourneyButtonClicked(_ sender: Any) {
        let journeySolutionViewController = getJourneySolutionViewController()
        navigationController?.pushViewController(journeySolutionViewController, animated: true)
    }
    
    private func getJourneySolutionViewController() -> JourneySolutionViewController {
        let bundle = Bundle(identifier: "org.cocoapods.NavitiaSDKUI")
        let storyboard = UIStoryboard(name: "Journey", bundle: bundle)
        let journeyResultsViewController = storyboard.instantiateInitialViewController() as! JourneySolutionViewController
        var params: JourneySolutionViewController.InParameters = JourneySolutionViewController.InParameters(originId: "2.3665844;48.8465337", destinationId: "2.2979169;48.8848719")
        params.originLabel = "Chez moi"
        params.destinationLabel = "Au travail"
        params.datetime = Date()
        params.datetime!.addTimeInterval(2000)
        params.datetimeRepresents = .departure
        params.forbiddenUris = ["physical_mode:Bus"]
        params.firstSectionModes = [.bss]
        params.lastSectionModes = [.car]
        params.count = 5
        journeyResultsViewController.inParameters = params
        return journeyResultsViewController
    }
    
    // Book
    @IBAction func onSDKBookButtonClicked(_ sender: Any) {
        let bundle = Bundle(identifier: "org.cocoapods.NavitiaSDKUI")
        let storyboard = UIStoryboard(name: "Book", bundle: bundle)
        bookShopViewController = storyboard.instantiateInitialViewController() as? BookShopViewController
        bookShopViewController?.delegate = self
        present(bookShopViewController!, animated: true, completion: nil)
    }
    
    func onDismissBookShopViewController() {
        if bookShopViewController != nil {
            bookShopViewController!.dismiss(animated: true, completion: nil)
        }
    }
    
}
