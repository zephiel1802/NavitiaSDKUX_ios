//
//  RoadmapTwoColumnsLayout.swift
//  NavitiaSDKUX
//
//  Created by Rachik Abidi on 13/12/2017.
//

import Foundation
import Render

extension Components.Journey.Roadmap.Sections.PublicTransport {
    class JourneyRoadmapTwoColumnsLayoutComponent: ViewComponent {
        var firstComponent: NodeType?
        var secondComponent: NodeType?
        
        override func render() -> NodeType {
            let computedStyles = mergeDictionaries(dict1: containerStyles, dict2: self.styles)
            let container = ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
                component.styles = computedStyles
            })
            
            var firstComponentChildren: [NodeType] = []
            if (self.firstComponent != nil) {
                firstComponentChildren.append(self.firstComponent!)
            }
            container.add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
                    component.styles = self.firstComponentStyles
                }).add(children: firstComponentChildren)
                ])
            
            var secondComponentChildren: [NodeType] = []
            if (self.secondComponent != nil) {
                secondComponentChildren.append(self.secondComponent!)
            }
            container.add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
                    component.styles = self.secondComponentStyles
                }).add(children: secondComponentChildren)
                ])
            
            return container
        }
        
        let firstComponentStyles: [String: Any] = [
            "width": 50,
            ]
        let secondComponentStyles: [String: Any] = [
            "flexGrow": 1,
            "flexShrink": 1,
            ]
        let containerStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
            ]
    }
}
