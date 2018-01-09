//
//  ListViewComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

class ListViewComponent: ViewComponent {
    override func render() -> NodeType {
        let computedStyles = self.styles
        return ComponentNode(ContainerComponent(), in: self, props: {(component: ContainerComponent, _) in
            component.styles = computedStyles
        })
    }
}
