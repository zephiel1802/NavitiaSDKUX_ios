//
//  DurationPart.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation

extension Components.Journey.Results.SolutionComponentParts {
    class DurationPart: ViewComponent {
        var seconds: Int32 = 0
        var hasArrow: Bool = false
        
        override func render() -> NodeType {
            let computedStyles: [String: Any] = self.styles
            var durationNodes: [NodeType] = []
            
            if self.seconds >= 3600 {
                let text = durationText(bundle: self.bundle, seconds: self.seconds)
                durationNodes = [
                    ComponentNode(TextComponent(), in: self, props: {(component, _) in
                        component.text = text
                        component.styles = self.digitsStyles
                    }),
                ]
            } else {
                durationNodes = [
                    ComponentNode(TextComponent(), in: self, props: {(component, _) in
                        component.text = String(self.seconds / 60)
                        component.styles = self.digitsStyles
                    }),
                    ComponentNode(TextComponent(), in: self, props: {(component, _) in
                        component.text = "min"
                        component.styles = self.abbrStyles
                    }),
                ]
            }
            
            if self.hasArrow {
                durationNodes.append(ComponentNode(IconComponent(), in: self, props: {(component, _) in
                    component.name = "arrow-right"
                    component.styles = self.arrowStyles
                }))
            }
            
            return ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                component.styles = computedStyles
            }).add(children: durationNodes)
        }
        
        let digitsStyles: [String: Any] = [
            "color": config.colors.tertiary,
            "fontWeight": "bold",
            "paddingRight": config.metrics.marginS,
        ]
        let abbrStyles: [String: Any] = [
            "color": config.colors.tertiary,
            "paddingRight": config.metrics.margin,
        ]
        let arrowStyles: [String: Any] = [
            "color": config.colors.tertiary,
            "fontSize": 16,
            "marginRight": config.metrics.marginS * -1,
        ]
    }
}
