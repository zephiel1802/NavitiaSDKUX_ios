//
//  JourneyRidesharingRoadmapViewController.swift
//  NavitiaSDKUX
//
//  Created by Rachik Abidi on 01/03/2018.
//

open class JourneyRidesharingRoadmapViewController: ViewController, ComponentController {
    var journey: Journey?
    var ridesharingJourney: Journey?
    var disruptions: [Disruption]?
    
    public var component: JourneyRidesharingSolutionRoadmapScreen = JourneyRidesharingSolutionRoadmapScreen()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("roadmap", bundle: bundle, comment: "Navigation bar title")
        addComponentToViewControllerHierarchyExtended()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func viewDidLayoutSubviews() {
        renderComponent(options: [.preventViewHierarchyDiff])
    }
    
    public func configureComponentProps() {
        component.journey = self.journey
        component.ridesharingJourney = self.ridesharingJourney
        component.disruptions = self.disruptions
        component.navigationController = navigationController
    }
}
