//
//  JourneyRowPart.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Results.SolutionComponentParts {
    class JourneyRowPart: ViewComponent {
        let SeparatorPart:Components.Journey.Results.Parts.SeparatorPart.Type = Components.Journey.Results.Parts.SeparatorPart.self
        let DurationPart:Components.Journey.Results.SolutionComponentParts.DurationPart.Type = Components.Journey.Results.SolutionComponentParts.DurationPart.self
        let JourneyFriezePart:Components.Journey.Results.SolutionComponentParts.JourneyFriezePart.Type = Components.Journey.Results.SolutionComponentParts.JourneyFriezePart.self
        let JourneyWalkingSummaryPart:Components.Journey.Results.SolutionComponentParts.JourneyWalkingSummaryPart.Type = Components.Journey.Results.SolutionComponentParts.JourneyWalkingSummaryPart.self
        
        var departureTime: String = ""
        var arrivalTime: String = ""
        var totalDuration: Int32? = 0
        var walkingDuration: Int32? = 0
        var walkingDistance: Int32? = 0
        var sections: [Section] = []
        var disruptions: [Disruption]?
        var hasArrow: Bool = false
        
        override func render() -> NodeType {
            let timesText = String(format: "%@ - %@", timeText(isoString: departureTime), timeText(isoString: arrivalTime))
            let computedStyles = self.styles
            
            var walkingSummaryComponent: NodeType = ComponentNode(ViewComponent(), in: self)
            if sections.count > 1 || self.walkingDuration! > 0 {
                walkingSummaryComponent = ComponentNode(JourneyWalkingSummaryPart.init(), in: self, props: {(component, _) in
                    component.duration = self.walkingDuration!
                    component.distance = self.walkingDistance!
                })
            }
            
            return ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                component.styles = computedStyles
            }).add(children: [
                ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                    component.styles = self.journeyHeaderStyles
                }).add(children: [
                    ComponentNode(TextComponent(), in: self, props: {(component, _) in
                        component.text = timesText
                        component.styles = self.timesStyles
                    }),
                    ComponentNode(DurationPart.init(), in: self, props: {(component, _) in
                        component.seconds = self.totalDuration!
                        component.styles = self.durationStyles
                        component.hasArrow = self.hasArrow
                    }),
                ]),
                ComponentNode(SeparatorPart.init(), in: self),
                ComponentNode(JourneyFriezePart.init(), in: self, props: {(component, _) in
                    component.sections = self.sections
                    component.disruptions = self.disruptions
                }),
                walkingSummaryComponent,
            ])
        }
        
        let journeyHeaderStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
            "paddingTop": config.metrics.marginL,
            "paddingBottom": config.metrics.marginL,
        ]
        let timesStyles: [String: Any] = [
            "color": config.colors.darkerGray,
            "fontWeight": "bold",
        ]
        let durationStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
            "alignItems": YGAlign.flexEnd,
            "justifyContent": YGJustify.flexEnd,
            "flexGrow": 1,
        ]
    }
}
