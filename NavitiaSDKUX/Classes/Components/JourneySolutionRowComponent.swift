//
//  JourneySolutionRowComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render
import NavitiaSDK

class JourneySolutionRowComponent: ViewComponent {
    var departureTime: String = ""
    var arrivalTime: String = ""
    var totalDuration: Int32? = 0
    var walkingDuration: Int32? = 0
    var walkingDistance: Int32? = 0
    var sections: [Section] = []
    var disruptions: [Disruption]?
    var hasArrow: Bool = false
    
    override func render() -> NodeType {
        let timesText = timeText(isoString: departureTime) + " - " + timeText(isoString: arrivalTime)
        let computedStyles = self.styles
        
        var walkingSummaryComponent: NodeType = ComponentNode(ViewComponent(), in: self)
        if self.walkingDuration! > 0 {
            walkingSummaryComponent = ComponentNode(JourneyWalkingSummaryComponent(), in: self, props: {(component, hasKey: Bool) in
                component.duration = self.walkingDuration!
                component.distance = self.walkingDistance!
            })
        }
        
        return ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        }).add(children: [
            ComponentNode(ViewComponent(), in: self).add(children: [
                ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
                    component.styles = self.journeyHeaderStyles
                }).add(children: [
                    ComponentNode(TextComponent(), in: self, props: {(component, hasKey: Bool) in
                        component.text = timesText
                        component.styles = self.timesStyles
                    }),
                    ComponentNode(DurationComponent(), in: self, props: {(component, hasKey: Bool) in
                        component.seconds = self.totalDuration!
                        component.styles = self.durationStyles
                        component.hasArrow = self.hasArrow
                    }),
                ]),
                ComponentNode(SeparatorComponent(), in: self),
                ComponentNode(JourneyRoadmapFriezeComponent(), in: self, props: {(component: JourneyRoadmapFriezeComponent, hasKey: Bool) in
                    component.sections = self.sections
                    component.disruptions = self.disruptions
                }),
                walkingSummaryComponent,
            ]),
        ])
    }
    
    let journeyHeaderStyles: [String: Any] = [
        "flexDirection": YGFlexDirection.row,
        "paddingTop": 16,
        "paddingBottom": 16,
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
