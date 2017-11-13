//
//  File.swift
//  RenderTest
//
//  Created by Thomas Noury on 02/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Render
import NavitiaSDK

class JourneySectionSummaryComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        var duration: Int32 = 0
        duration = self.section!.duration!
        let containerStyles: [String: Any] = [
            "fontSize": 16,
            "flexGrow": Int(duration),
            "marginEnd": config.metrics.margin,
        ]

        return ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = mergeDictionaries(dict1: containerStyles, dict2: self.styles)
        }).add(children: [
            ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, hasKey: Bool) in
                component.styles = self.viewStyles
            }).add(children: [
                ComponentNode(ModeComponent(), in: self, props: {(component: ModeComponent, hasKey: Bool) in
                    component.section = self.section
                    component.styles = self.modeStyles
                }),
                ComponentNode(LineCodeWithDisruptionStatus(), in: self, props: {(component: LineCodeWithDisruptionStatus, hasKey: Bool) in
                    component.section = self.section
                })
            ]),
            ComponentNode(JourneySectionSegmentComponent(), in: self, props: {(component: JourneySectionSegmentComponent, hasKey: Bool) in
                component.section = self.section
            }),
        ])
    }

    let viewStyles: [String: Any] = [
        "flexDirection": YGFlexDirection.row,
        "marginBottom": 12,
    ]
    let modeStyles = [
        "marginRight": config.metrics.marginS,
        "height": 28,
    ]
}
