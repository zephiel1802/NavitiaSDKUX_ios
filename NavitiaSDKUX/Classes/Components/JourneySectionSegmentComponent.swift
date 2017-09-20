//
//  JourneySectionSegmentComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 02/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Render
import NavitiaSDK

class JourneySectionSegmentComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        var color: UIColor = config.colors.darkerGray

        if (self.section!.displayInformations != nil) {
            color = getUIColorFromHexadecimal(hex: (self.section!.displayInformations?.color)!)
        }

        let containerStyles: [String: Any] = [
            "backgroundColor": color,
            "borderRadius": 3,
            "height": 5,
        ]
        let computedStyles = mergeDictionaries(dict1: containerStyles, dict2: self.styles)
        return ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        })
    }
}
