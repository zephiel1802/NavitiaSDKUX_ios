//
//  JourneyRidesharing2ColumnsLayout.swift
//  NavitiaSDKUX
//
//  Created by Rachik Abidi on 19/02/2018.
//

import Foundation
import Render

extension Components.Journey.Results.SolutionComponentParts {
    class JourneyRidesharing2ColumnsLayout : ViewComponent {
        var leftChildren: [NodeType]?
        var rightChildren: [NodeType]?
        var showSeparator: Bool = false
        
        override func render() -> NodeType {
            let computedStyles = mergeDictionaries(dict1: containerStyles, dict2: self.styles)
            let container = ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                component.styles = computedStyles
            })
            container.add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                    component.styles = self.leftComponentStyles
                }).add(children:  self.leftChildren ?? [])
            ])
            if showSeparator {
                container.add(children: [
                    ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                        component.styles = self.separatorStyles
                    })
                ])
            }
            container.add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                    component.styles = self.rightComponentStyles
                }).add(children:  self.rightChildren ?? [])
            ])
            
            return container
        }
        
        let rightComponentStyles: [String: Any] = [
            "width": 140,
            "alignItems": YGAlign.flexEnd,
        ]
        let leftComponentStyles: [String: Any] = [
            "flexGrow": 1,
            "flexShrink": 1,
        ]
        let separatorStyles: [String: Any] = [
            "width": 1,
            "backgroundColor": config.colors.secondary,
        ]
        let containerStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
        ]
    }
}
