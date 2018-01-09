//
//  ListRow.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

class CardComponent: ViewComponent {
    override func render() -> NodeType {
        let computedStyles = mergeDictionaries(dict1: self.defaultStyles, dict2: self.styles)
        return ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, _) in
            component.styles = computedStyles
        })
    }
    
    let defaultStyles: [String: Any] = [
        "backgroundColor": UIColor.white,
        "borderRadius": config.metrics.radius,
        "shadowRadius": 2.0,
        "shadowOpacity": 0.12,
        "shadowOffset": [0, 0],
        "shadowColor": UIColor.black,
    ]
}
