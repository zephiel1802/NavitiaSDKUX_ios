//
//  JourneySolutionComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Results {
    class JourneySolutionComponent: ViewComponent {
        let JourneyRowPart:Components.Journey.Results.SolutionComponentParts.JourneyRowPart.Type = Components.Journey.Results.SolutionComponentParts.JourneyRowPart.self
        
        var navigationController: UINavigationController?
        var journey: Journey = Journey()
        var disruptions: [Disruption]?
        var hasArrow: Bool = true
        var isRidesharingComponent: Bool = false

        override func render() -> NodeType {
            let computedStyles = mergeDictionaries(dict1: listStyles, dict2: self.styles)
            let walkingDistance = getWalkingDistance(sections: journey.sections!)

            return ComponentNode(ActionComponent(), in: self, props: {(component, _) in
                component.onTap = { _ in
                    if self.hasArrow {
                        if self.isRidesharingComponent {
                            let journeyRidesharingSolutionsViewController: JourneyRidesharingSolutionsViewController = JourneyRidesharingSolutionsViewController()
                            journeyRidesharingSolutionsViewController.journey = self.journey
                            journeyRidesharingSolutionsViewController.disruptions = self.disruptions
                            self.navigationController?.pushViewController(journeyRidesharingSolutionsViewController, animated: true)
                        } else {
                            let journeySolutionRoadmapController: JourneySolutionRoadmapController = JourneySolutionRoadmapController()
                            journeySolutionRoadmapController.journey = self.journey
                            journeySolutionRoadmapController.disruptions = self.disruptions
                            self.navigationController?.pushViewController(journeySolutionRoadmapController, animated: true)
                        }
                    }
                }}).add(children: [
                    ComponentNode(CardComponent(), in: self, props: { (component, _) in
                        component.styles = computedStyles
                    }).add(children: [
                        ComponentNode(JourneyRowPart.init(), in: self, props: {(component, _) in
                            component.departureTime = self.journey.departureDateTime!
                            component.arrivalTime = self.journey.arrivalDateTime!
                            component.totalDuration = self.journey.duration
                            component.walkingDuration = self.journey.durations?.walking
                            component.walkingDistance = walkingDistance
                            component.sections = self.journey.sections!
                            component.disruptions = self.disruptions
                            component.hasArrow = self.hasArrow
                        })
                    ])
                ])
        }
        
        func getWalkingDistance(sections: [Section]) -> Int32 {
            var distance: Int32 = 0
            for section in sections {
                if section.type == "street_network" && section.mode == "walking" {
                    for segment in section.path! {
                        distance += segment.length!
                    }
                }
            }
            return distance
        }
        
        let listStyles:[String: Any] = [
            "backgroundColor": config.colors.white,
            "padding": config.metrics.marginL,
            "paddingTop": config.metrics.marginS,
            "borderRadius": config.metrics.radius,
            "marginBottom": config.metrics.margin,
            "shadowRadius": 2.0,
            "shadowOpacity": 0.12,
            "shadowOffset": [0, 0],
            "shadowColor": UIColor.black,
        ]
    }
}
