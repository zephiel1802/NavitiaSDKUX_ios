//
//  JourneyRoadmapFriezeComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render
import NavitiaSDK

class JourneyRoadmapFriezeComponent: ViewComponent {
    var sections: [Section] = []
    var disruptions: [Disruption]?

    override func render() -> NodeType {
        let computedStyles = mergeDictionaries(dict1: containerStyles, dict2: self.styles)
        let sectionComponents = getSectionComponents(sections: self.sections)
        return ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
            component.styles = computedStyles
        }).add(children: [
            ComponentNode(SeparatorComponent(), in: self),
            ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
                component.styles = self.modeListStyles
            }).add(children: sectionComponents)
        ])
    }

    func getSectionComponents(sections: [Section]) -> [NodeType] {
        return sections.filter { section in
            return (section.type! == "public_transport" || section.type! == "street_network")
        }.map { section -> NodeType in
            var sectionDisruptions: [Disruption] = []
            if section.type == "public_transport" {
                sectionDisruptions = section.getMatchingDisruptions(from: self.disruptions)
            }
            return ComponentNode(JourneySectionSummaryComponent(), in: self, props: { (component: JourneySectionSummaryComponent, hasKey: Bool) in
                component.section = section
                component.disruptions = sectionDisruptions
            })
        }
    }

    let containerStyles: [String: Any] = [
        "flexDirection": YGFlexDirection.row,
    ]

    let modeListStyles: [String: Any] = [
        "paddingTop": config.metrics.marginL,
        "paddingBottom": config.metrics.marginL,
        "flexDirection": YGFlexDirection.row,
        "flexGrow": 1,
        "marginEnd": config.metrics.margin * -1
    ]
}
