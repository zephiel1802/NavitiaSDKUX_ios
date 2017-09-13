//
//  LineCodeComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 02/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Render
import NavitiaSDK

class LineCodeComponent: ViewComponent {
    var section: Section?


    override func render() -> NodeType {
        var code: String = ""
        var lineBackgroundColor: UIColor = UIColor()
        var lineTextColor: UIColor = UIColor()

        code = self.section!.displayInformations!.code!
        lineBackgroundColor = getUIColorFromHexadecimal(hex: (self.section!.displayInformations!.color)!)
        lineTextColor = getUIColorFromHexadecimal(hex: (self.section!.displayInformations!.textColor)!)

        let codeStyles:[String: Any] = [
            "backgroundColor": lineBackgroundColor,
            "borderRadius": 3,
            "padding": 6,
        ]
        let textStyles: [String: Any] = [
            "color": lineTextColor,
            "fontSize": 12,
            "fontWeight": "bold",
        ]
        let computedStyles = mergeDictionaries(dict1: codeStyles, dict2: self.styles)
        return ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        }).add(children: [
            ComponentNode(TextComponent(), in: self, props: {(component, hasKey: Bool) in
                component.text = code
                component.styles = textStyles
            })
        ])
    }
}
