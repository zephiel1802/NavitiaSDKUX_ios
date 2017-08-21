//
//  JourneySectionSegmentComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 02/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Render

class JourneySectionSegmentComponent: ViewComponent {
    var color: UIColor = UIColor()
    
    override func render() -> NodeType {
        let containerStyles: [String: Any] = [
            "backgroundColor": self.color,
            "borderRadius": 3,
            "height": 5,
        ]
        let computedStyles = mergeDictionaries(dict1: containerStyles, dict2: self.styles)
        return ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        })
    }
}
