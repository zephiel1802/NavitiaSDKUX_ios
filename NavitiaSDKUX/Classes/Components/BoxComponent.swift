//
//  BoxComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

class BoxComponent: ViewComponent {
    override func render() -> NodeType {
        let computedStyles: [String: Any] = self.styles
        return ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, _) in
            component.styles = computedStyles
        })
    }
}
