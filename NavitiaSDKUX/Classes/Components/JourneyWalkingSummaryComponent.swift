//
//  JourneyWalkingAbstractComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 03/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Render

class JourneyWalkingSummaryComponent: ViewComponent {
    var duration: Int32 = 0
    var distance: Int32 = 0
    
    override func render() -> NodeType {
        let computedStyles = mergeDictionaries(dict1: containerStyles, dict2: self.styles)
        return ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        }).add(children: [
            ComponentNode(TextComponent(), in: self, props: {(component, hasKey: Bool) in
                component.text = NSLocalizedString("component.JourneyWalkingSummaryComponent.With", bundle: self.bundle, comment: "Context: With 16 min walking (712m)") + " "
            }),
            ComponentNode(TextComponent(), in: self, props: {(component, hasKey: Bool) in
                component.text = durationText(bundle: self.bundle, seconds: self.duration)
                component.styles = self.durationStyles
            }),
            ComponentNode(TextComponent(), in: self, props: {(component, hasKey: Bool) in
                component.text = " " + NSLocalizedString("component.JourneyWalkingSummaryComponent.walking", bundle: self.bundle, comment: "Context: With 16 min walking (712m)")
                component.text += " (" + distanceText(bundle: self.bundle, meters: self.distance) + ")"
            }),
        ])
    }

    let containerStyles: [String: Any] = [
        "flexDirection": YGFlexDirection.row,
    ]
    let durationStyles: [String: Any] = [
        "fontWeight": "bold",
    ]
}
