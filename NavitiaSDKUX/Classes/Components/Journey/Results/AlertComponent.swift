//
//  AlertComponent.swift
//  NavitiaSDK UX
//
//  Created by Thomas Noury on 21/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Render

enum AlertStatus: Int {
    case info = 0
    case success = 1
    case warning = 2
    case error = 3
}

extension Components.Journey.Results {
    class AlertComponent: ViewComponent {
        var text: String = "Test"
        var status: AlertStatus = AlertStatus.info
        
        override func render() -> NodeType {
            let computedContainerStyles: [String: Any] = [
                "backgroundColor": statusBackgroundColors[self.status]!,
                "borderColor": statusForegroundColors[self.status]!,
                "borderWidth": 1,
            ]
            let computedTextStyles: [String: Any] = [
                "color": statusForegroundColors[self.status]!,
            ]
            return ComponentNode(ContainerComponent(), in: self, props: {(component, _) in
                component.styles = computedContainerStyles
            }).add(children: [
                ComponentNode(TextComponent(), in: self, props: {(component, _) in
                    component.text = self.text
                    component.styles = computedTextStyles
                })
            ])
        }
        
        let statusBackgroundColors: [AlertStatus: UIColor] = [
            AlertStatus.info: UIColor(red:0.85, green:0.93, blue:0.97, alpha:1.0),
            AlertStatus.success: UIColor(red:0.87, green:0.94, blue:0.85, alpha:1.0),
            AlertStatus.warning: UIColor(red:0.99, green:0.97, blue:0.89, alpha:1.0),
            AlertStatus.error: UIColor(red:0.95, green:0.87, blue:0.87, alpha:1.0),
        ]
        let statusForegroundColors: [AlertStatus: UIColor] = [
            AlertStatus.info: UIColor(red:0.19, green:0.44, blue:0.56, alpha:1.0),
            AlertStatus.success: UIColor(red:0.24, green:0.46, blue:0.24, alpha:1.0),
            AlertStatus.warning: UIColor(red:0.54, green:0.43, blue:0.23, alpha:1.0),
            AlertStatus.error: UIColor(red:0.66, green:0.27, blue:0.26, alpha:1.0),
        ]
    }
}
