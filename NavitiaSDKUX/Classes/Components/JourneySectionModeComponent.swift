//
//  JourneySectionModeComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 27/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

class JourneySectionModeComponent: ViewComponent {
    override func render() -> NodeType {
        let computedStyles = self.styles
        return ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        }).add(children: [
            ComponentNode(ModeComponent(), in: self, props: {(component, hasKey: Bool) in
                component.name = "walking"
            }),
        ])
    }
}
