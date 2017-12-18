//
//  RoadmapTwoColumnsLayout.swift
//  NavitiaSDKUX
//
//  Created by Rachik Abidi on 13/12/2017.
//

import Foundation
import Render

extension Components.Journey.Roadmap.Sections.PublicTransport {
    class JourneyRoadmap2ColumnsLayout: ViewComponent {
        var leftChildren: NodeType?
        var rightChildren: NodeType?
        
        override func render() -> NodeType {
            let computedStyles = mergeDictionaries(dict1: containerStyles, dict2: self.styles)
            let container = ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
                component.styles = computedStyles
            })
            
            var leftComponentChildren: [NodeType] = []
            if (self.leftChildren != nil) {
                leftComponentChildren.append(self.leftChildren!)
            }
            container.add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
                    component.styles = self.leftComponentStyles
                }).add(children: leftComponentChildren)
            ])
            
            var rightComponentChildren: [NodeType] = []
            if (self.rightChildren != nil) {
                rightComponentChildren.append(self.rightChildren!)
            }
            container.add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
                    component.styles = self.rightComponentStyles
                }).add(children: rightComponentChildren)
            ])
            
            return container
        }
        
        let leftComponentStyles: [String: Any] = [
                "width": 50,
            ]
        let rightComponentStyles: [String: Any] = [
                "flexGrow": 1,
                "flexShrink": 1
            ]
        let containerStyles: [String: Any] = [
                "flexDirection": YGFlexDirection.row,
            ]
    }
}
