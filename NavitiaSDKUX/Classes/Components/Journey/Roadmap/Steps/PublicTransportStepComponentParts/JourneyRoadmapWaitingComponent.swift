import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts {
    class WaitingPart: ViewComponent {
        var waitingTime: Int32!

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, _) in
                component.styles = self.containerStyles
            }).add(children: [
                ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, _) in
                    component.styles = self.iconContainerStyles
                }).add(children: [
                    ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, _) in
                        component.name = "clock"
                        component.styles = self.iconStyles
                    })
                ]),
                ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, _) in
                    component.styles = self.labelContainerStyles
                }).add(children: [
                    ComponentNode(TextComponent(), in: self, props: {(component: TextComponent, _) in
                        component.styles = self.labelStyles
                        let action: String = NSLocalizedString("journey.roadmap.action.wait", bundle: self.bundle, comment: "Action description")
                        component.text = "\(action) \(durationText(bundle: self.bundle, seconds: self.waitingTime, useFullFormat: true))"
                    })
                ])
            ])
        }

        let containerStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
            "marginTop": config.metrics.margin,
        ]
        let iconContainerStyles: [String: Any] = [
            "justifyContent": YGJustify.center,
        ]
        let iconStyles: [String: Any] = [
            "color": config.colors.gray,
            "fontSize": 18,
        ]
        let labelContainerStyles: [String: Any] = [
            "padding": 6,
            ]
        let labelStyles: [String: Any] = [
            "fontSize": config.metrics.textS,
            "color": config.colors.gray,
        ]
    }
}
