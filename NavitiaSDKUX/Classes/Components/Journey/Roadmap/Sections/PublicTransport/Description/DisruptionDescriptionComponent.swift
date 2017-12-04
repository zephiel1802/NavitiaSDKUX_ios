import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.PublicTransport.Description {
    class DisruptionDescriptionComponent: ViewComponent {
        var section: Section?
        var disruptions: [Disruption]?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.styles
            }).add(children: disruptions!.map { disruption -> NodeType in
                return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.containerStyles
                }).add(children: [
                    ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                        component.styles = self.disruptionTitleStyles
                    }).add(children: [
                        ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, _) in
                            component.name = Disruption.getIconName(of: disruption.level)
                            self.iconStyles["color"] = getUIColorFromHexadecimal(hex: Disruption.getLevelColor(of: disruption.level))
                            component.styles = self.iconStyles
                        }),
                        ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                            component.styles = self.containerCauseStyles
                        }).add(children: [
                            ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                                component.styles = self.causeStyles
                                component.styles["color"] = getUIColorFromHexadecimal(hex: Disruption.getLevelColor(of: disruption.level))
                                component.text = disruption.cause!
                            })
                        ])
                    ]),
                    ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                        component.styles = self.disruptionTextContainerStyles
                    }).add(children: [
                        ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                            component.styles = self.disruptionTextStyles
                            component.text = disruption.messages!.first!.escapedText!
                        })
                    ])
                ])
            })
        }

        let containerStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.column,
            "marginTop": 26,
        ]
        let disruptionTitleStyles: [String: Any] = [
            "alignItems": YGAlign.center,
            "flexDirection": YGFlexDirection.row,
        ]
        var iconStyles: [String: Any] = [
            "fontSize": 16,
        ]
        let containerCauseStyles: [String: Any] = [
            "marginLeft": 4,
            "alignItems": YGAlign.center,
        ]
        let causeStyles: [String: Any] = [
            "fontSize": 15,
            "fontWeight": "bold"
        ]
        let disruptionTextContainerStyles: [String: Any] = [
            :
        ]
        let disruptionTextStyles: [String: Any] = [
            "color": UIColor.lightGray,
            "fontSize": 15,
        ]
    }
}
