//
//  JourneyRidesharingDetailsScreen.swift
//  NavitiaSDKUX
//
//  Created by Rachik Abidi on 16/02/2018.
//

import Foundation

open class JourneyRidesharingSolutionsScreen: StatelessComponentView {
    let JourneySolutionComponent: Components.Journey.Results.JourneySolutionComponent.Type = Components.Journey.Results.JourneySolutionComponent.self
    let RidesharingSolutionComponent: Components.Journey.Results.RidesharingSolutionComponent.Type = Components.Journey.Results.RidesharingSolutionComponent.self
    
    var navigationController: UINavigationController?
    var journey: Journey?
    var disruptions: [Disruption]?
    
    open override func render() -> NodeType {
        let ridesharingSolutionComponents = self.getRidesharingSolutionComponents(journey: self.journey!)
        
        return ComponentNode(ScreenComponent(), in: self).add(children: [
            ComponentNode(ScreenHeaderComponent(), in: self, props: { (component, _) in
                component.navigationController = self.navigationController
                component.styles = self.screenHeaderStyle
            }),
            ComponentNode(ViewComponent(), in: self).add(children: [
                ComponentNode(JourneySolutionComponent.init(), in: self, props: { (component, _) in
                    component.journey = self.journey!
                    component.disruptions = self.disruptions
                    component.hasArrow = false
                    component.isRidesharingComponent = true
                })
            ]),
            ComponentNode(ScrollViewComponent(), in: self).add(children: [
                ComponentNode(ListViewComponent(), in: self).add(children: ridesharingSolutionComponents)
            ])
        ])
    }
    
    open override func componentDidMount() {
        self.update()
    }
    
    func getRidesharingSolutionComponents(journey: Journey) -> [NodeType] {
        var resultComponents: [NodeType] = [NodeType]()
        for (_, section) in (journey.sections?.enumerated())! {
            if section.type == "street_network" && section.mode == "ridesharing" {
                for (_, ridesharingJourney) in (section.ridesharingJourneys?.enumerated())! {
                    resultComponents.append(ComponentNode(RidesharingSolutionComponent.init(), in: self, props: {(component, _) in
                        component.navigationController = self.navigationController
                        component.journey = self.journey
                        component.ridesharingJourney = ridesharingJourney
                        component.disruptions = self.disruptions
                        
                        component.initRidesharingJourneyInfo()
                    }))
                }
            }
        }
        
        return resultComponents
    }
    
    let screenHeaderStyle: [String: Any] = [
        "backgroundColor": config.colors.tertiary,
        "height": 20,
    ]
}
