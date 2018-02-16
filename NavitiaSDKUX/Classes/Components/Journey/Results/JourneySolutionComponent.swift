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
                        let journeySolutionRoadmapController: JourneySolutionRoadmapController = JourneySolutionRoadmapController()
                        journeySolutionRoadmapController.journey = self.journey
                        journeySolutionRoadmapController.disruptions = self.disruptions
                        self.navigationController?.pushViewController(journeySolutionRoadmapController, animated: true)
                    } else if self.isRidesharingComponent, let ridesharingDeepLink = self.getRidesharingDeepLink() {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(ridesharingDeepLink, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(ridesharingDeepLink)
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
        
        func getRidesharingDeepLink() -> URL? {
            for (_, section) in (self.journey.sections?.enumerated())! {
                if section.type == "street_network" && section.mode == "ridesharing" {
                    for (_, journeySection) in (section.ridesharingJourneys![0].sections?.enumerated())! {
                        if journeySection.type == "ridesharing" && journeySection.links != nil && journeySection.links!.count > 0 {
                            for (_, linkSchema) in (journeySection.links?.enumerated())! {
                                if linkSchema.type == "ridesharing_ad" && linkSchema.href != nil {
                                    return URL(string: linkSchema.href!)
                                }
                            }
                        }
                    }
                }
            }
            return nil
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
