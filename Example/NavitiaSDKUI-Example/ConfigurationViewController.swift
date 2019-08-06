//
//  ConfigurationViewController.swift
//  NavitiaSDKUI-Example
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit
import NavitiaSDKUI

class ConfigurationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: variables
    var selectedCoverage: String?
    
    @IBOutlet weak var coveragePickerView: UIPickerView!
    @IBOutlet weak var formSwitch: UISwitch!
    @IBOutlet weak var selectedCoverageLabel: UILabel!
    
    var coverages: [String] = []
    var coverageIds: [String] = []
    
    // MARK: inherits
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedCoverageLabel.text = String(format: "Coverage : %@\nId : %@", coverages[0], coverageIds[0])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: IBActions
    @IBAction func letsGoClicked(_ sender: Any) {
        selectedCoverage = coverageIds[coveragePickerView.selectedRow(inComponent: 0)]
        
        if formSwitch.isOn {
            launchWithForm()
        } else {
            launchWithoutForm()
        }
    }
    
    // MARK: Picker: Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coverages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coverages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCoverageLabel.text = String(format: "Coverage : %@\nId : %@", coverages[row], coverageIds[row])
    }
    
    // MARK: private methods
    
    private func launchWithForm() {
        if let formJourneyViewController = getFormJourneyViewController() {
            navigationController?.pushViewController(formJourneyViewController, animated: true)
        }
    }
    
    private func launchWithoutForm() {
        if let listJourneysViewController = getListJourneysViewController() {
            navigationController?.pushViewController(listJourneysViewController, animated: true)
        }
    }
    
    private func getListJourneysViewController() -> UIViewController? {
        NavitiaSDKUI.shared.formJourney = false
        
        guard let journeyResultsViewController = NavitiaSDKUI.shared.rootViewController else {
            return nil
        }
        
        let journeysRequest = JourneysRequest(coverage: selectedCoverage!)
        journeysRequest.originId = "2.3665844;48.8465337"
        journeysRequest.originLabel = "Chez moi"
        journeysRequest.destinationId = "2.2979169;48.8848719"
        journeysRequest.destinationLabel = "Au travail"
        journeysRequest.datetime = Date()
        journeysRequest.datetime!.addTimeInterval(7200)
        journeysRequest.datetimeRepresents = .departure
        journeysRequest.forbiddenUris = ["physical_mode:Bus"]
        journeysRequest.firstSectionModes = [.walking, .car, .bike, .bss, .ridesharing]
        journeysRequest.lastSectionModes = [.walking, .car, .bike, .bss, .ridesharing]
        journeysRequest.count = 5
        
        journeyResultsViewController.journeysRequest = journeysRequest
        
        return journeyResultsViewController as? UIViewController
    }
    
    private func getFormJourneyViewController() -> UIViewController? {
        NavitiaSDKUI.shared.formJourney = true
        NavitiaSDKUI.shared.modeForm = [ModeButtonModel(title: "Metro", icon: "metro", selected: true, firstSectionMode: ["walking"], lastSectionMode: ["walking"], physicalMode: ["physical_mode:Metro"]),
                                        ModeButtonModel(title: "Bus", icon: "bus", selected: true, firstSectionMode: ["walking"], lastSectionMode: ["walking"], physicalMode: ["physical_mode:Bus"]),
                                        ModeButtonModel(title: "RER", icon: "train", selected: true, firstSectionMode: ["walking"], lastSectionMode: ["walking"], physicalMode: ["physical_mode:RapidTransit"]),
                                        ModeButtonModel(title: "Tramway", icon: "tramway", selected: false, firstSectionMode: ["walking"], lastSectionMode: ["walking"], physicalMode: ["physical_mode:Tramway"]),
                                        ModeButtonModel(title: "Train", icon: "train", selected: false, firstSectionMode: ["walking"], lastSectionMode: ["walking"], physicalMode: ["physical_mode:LocalTrain", "physical_mode:Train"]),
                                        ModeButtonModel(title: "Navette", icon: "train", selected: false, firstSectionMode: ["walking"], lastSectionMode: ["walking"], physicalMode: ["physical_mode:Shuttle"]),
                                        ModeButtonModel(title: "Vélo", icon: "bike", selected: false, firstSectionMode: ["bike"], lastSectionMode: ["bike"]),
                                        ModeButtonModel(title: "VLS", icon: "bss", selected: false, firstSectionMode: ["bss"], lastSectionMode: ["bss"], realTime: true),
                                        ModeButtonModel(title: "Voiture", icon: "car", selected: false, firstSectionMode: ["car"], lastSectionMode: ["car"], realTime: true)]
        
        guard let journeyResultsViewController = NavitiaSDKUI.shared.rootViewController else {
            return nil
        }
        
        let journeysRequest = JourneysRequest(coverage: selectedCoverage!)
        journeyResultsViewController.journeysRequest = journeysRequest
        
        return journeyResultsViewController as? UIViewController
    }
}
