//
//  TextComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

class TextComponent: LabelComponent {
    override func render() -> NodeType {
        let computedStyles = mergeDictionaries(dict1: textStyles, dict2: self.styles)
        return ComponentNode(LabelComponent(), in: self, props: {(component, hasKey: Bool) in
            component.text = self.text
            component.styles = computedStyles
        })
    }
    
    let textStyles: [String: Any] = [
        "color": config.colors.primary,
    ]
}
