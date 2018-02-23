//
//  JourneyRidesharingDetailsViewController.swift
//  NavitiaSDKUX
//
//  Created by Rachik Abidi on 16/02/2018.
//

import Render
import NavitiaSDK

open class JourneyRidesharingSolutionsViewController: ViewController, ComponentController {
    var journey: Journey?
    var disruptions: [Disruption]?
    
    public var component: JourneyRidesharingSolutionsScreen = JourneyRidesharingSolutionsScreen()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("carpooling", bundle: self.bundle, comment: "Carpooling")
        addComponentToViewControllerHierarchy()
    }
    
    override open func viewDidLayoutSubviews() {
        renderComponent(options: [.preventViewHierarchyDiff])
    }
    
    public func configureComponentProps() {
        component.journey = self.journey
        component.disruptions = self.disruptions
        component.navigationController = navigationController
    }
}
