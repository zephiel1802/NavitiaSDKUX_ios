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
                })
                    .add(children: [
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
                    ])
            })
        }

        let containerStyles: [String: Any] = [
            "alignItems": YGAlign.center,
            "flexDirection": YGFlexDirection.row,
            "marginTop": 26,
        ]
        var iconStyles: [String: Any] = [
            "fontSize": 16,
        ]
        let containerCauseStyles: [String: Any] = [
            "marginLeft": 4,
            "alignItems": YGAlign.center,
//            "justifyContent": YGJustify.center,
        ]
        let causeStyles: [String: Any] = [
            "fontSize": 15,
            "fontWeight": "bold"
        ]
    }
}
