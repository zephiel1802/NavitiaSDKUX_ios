//
//  LineCodeComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 02/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Render

class LineCodeComponent: ViewComponent {
    var code: String = ""
    var lineBackgroundColor: UIColor = UIColor()
    var lineTextColor: UIColor = UIColor()
    
    override func render() -> NodeType {
        let codeStyles:[String: Any] = [
            "backgroundColor": self.lineBackgroundColor,
            "borderRadius": 3,
            "padding": 6,
        ]
        let textStyles: [String: Any] = [
            "color": self.lineTextColor,
            "fontSize": 12,
            "fontWeight": "bold",
        ]
        let computedStyles = mergeDictionaries(dict1: codeStyles, dict2: self.styles)
        return ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        }).add(children: [
            ComponentNode(TextComponent(), in: self, props: {(component, hasKey: Bool) in
                component.text = self.code
                component.styles = textStyles
            })
        ])
    }
    
    
}
