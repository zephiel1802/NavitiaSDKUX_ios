//
//  File.swift
//  RenderTest
//
//  Created by Thomas Noury on 02/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Render
import NavitiaSDK

class JourneySectionAbstractComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        var duration: Int32 = 0
        var lineCode: String? = nil
        var lineBackgroundColor: UIColor? = nil
        var lineTextColor: UIColor? = nil

        if (self.section!.displayInformations != nil) {
            lineBackgroundColor = getUIColorFromHexadecimal(hex: (self.section!.displayInformations?.color)!)
            lineTextColor = getUIColorFromHexadecimal(hex: (self.section!.displayInformations?.textColor)!)
            lineCode = self.section!.displayInformations?.code
        }
        duration = self.section!.duration!

        let containerStyles: [String: Any] = [
            "fontSize": 16,
            "flexGrow": Int(duration),
            "marginEnd": config.metrics.margin,
        ]
        let computedStyles = mergeDictionaries(dict1: containerStyles, dict2: self.styles)
        
        var symbolComponents: [NodeType] = [
            ComponentNode(ModeComponent(), in: self, props: {(component: ModeComponent, hasKey: Bool) in
                component.section = self.section
                component.styles = self.modeStyles
            })
        ]
        var segmentColor: UIColor = config.colors.darkerGray
        
        if (lineCode != nil) {
            symbolComponents.append(ComponentNode(LineCodeComponent(), in: self, props: {(component, hasKey: Bool) in
                component.code = lineCode!
                component.lineBackgroundColor = lineBackgroundColor!
                component.lineTextColor = lineTextColor!
            }))
            segmentColor = lineBackgroundColor!
        }
        
        return ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        }).add(children: [
            ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
                component.styles = self.viewStyles
            }).add(children: symbolComponents),
            ComponentNode(JourneySectionSegmentComponent(), in: self, props: {(component, hasKey: Bool) in
                component.color = segmentColor
            }),
        ])
    }
    let viewStyles: [String: Any] = [
        "flexDirection": YGFlexDirection.row,
        "marginBottom": 12,
    ]
    let modeStyles = [
        "marginRight": config.metrics.marginS,
        "height": 28,
    ]
}
