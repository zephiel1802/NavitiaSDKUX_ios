//
//  JourneyRidesharingSolutionRoadmapScreen.swift
//  NavitiaSDKUX
//
//  Created by Rachik Abidi on 01/03/2018.
//

import Foundation

open class JourneyRidesharingSolutionRoadmapScreen: StatelessComponentView {
    let JourneySolutionComponent: Components.Journey.Results.JourneySolutionComponent.Type = Components.Journey.Results.JourneySolutionComponent.self
    let RidesharingSolutionComponent: Components.Journey.Results.RidesharingSolutionComponent.Type = Components.Journey.Results.RidesharingSolutionComponent.self
    
    var navigationController: UINavigationController?
    var journey: Journey?
    var ridesharingJourney: Journey?
    var disruptions: [Disruption]?
    
    open override func componentDidMount() {
        self.update()
        for childComponentView in self.childrenComponent.enumerated() {
            if let mapViewComponent = childComponentView.element.value as? JourneyMapViewComponent {
                mapViewComponent.componentDidMount()
            }
        }
    }
    
    override open func render() -> NodeType {
        return ComponentNode(ScreenComponent(), in: self).add(children: [
            ComponentNode(ScreenHeaderComponent(), in: self, props: { (component, _) in
                component.navigationController = self.navigationController
                component.styles = self.screenHeaderStyle
            }),
            Node<UIView>() { view, layout, size in
                layout.height = 0.4 * size.height
                }.add(children: [
                    ComponentNode(JourneyMapViewComponent(), in: self, props: { (component, _) in
                        component.styles = self.mapViewStyles
                        component.journey = self.journey
                        component.ridesharingJourney = self.ridesharingJourney
                })
            ]),
            ComponentNode(ScrollViewComponent(), in: self).add(children: [
                ComponentNode(JourneySolutionComponent.init(), in: self, props: { (component, _) in
                    component.journey = self.journey!
                    component.disruptions = self.disruptions
                    component.hasArrow = false
                }),
                ComponentNode(ListViewComponent(), in: self).add(children: [
                    ComponentNode(RidesharingSolutionComponent.init(), in: self, props: {(component, _) in
                        component.navigationController = self.navigationController
                        component.journey = self.journey
                        component.ridesharingJourney = self.ridesharingJourney
                        component.disruptions = self.disruptions
                        component.isRoadmapComponent = true
                        
                        component.initRidesharingJourneyInfo()
                    })
                ])
            ])
        ])
    }
    
    let screenHeaderStyle: [String: Any] = [
        "backgroundColor": config.colors.tertiary,
        "height": 20,
    ]
    let mapViewStyles: [String: Any] = [
        "flexGrow": 1,
    ]
}
