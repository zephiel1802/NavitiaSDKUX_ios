//
//  DurationComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

class DurationComponent: ViewComponent {
    var seconds: Int32 = 0
    
    override func render() -> NodeType {
        let computedStyles = self.styles
        return ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        }).add(children: [
            ComponentNode(TextComponent(), in: self, props: {(component, hasKey: Bool) in
                component.text = String(Int(ceil(Double(self.seconds) / 60)))
                component.styles = self.digitsStyles
            }),
            ComponentNode(TextComponent(), in: self, props: {(component, hasKey: Bool) in
                component.text = "min"
                component.styles = self.abbrStyles
            })
        ])
    }
    
    let digitsStyles: [String: Any] = [
        "color": config.colors.tertiary,
        "fontSize": 26,
        "fontWeight": "bold",
        "marginBottom": -4,
    ]
    let abbrStyles: [String: Any] = [
        "color": config.colors.tertiary,
        "fontSize": 12,
        "marginBottom": 4,
    ]
}
