import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.PublicTransport.Description {
    class DisruptionDescription: ViewComponent {
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
                        ComponentNode(DisruptionBadgeComponent(), in: self, props: { (component: DisruptionBadgeComponent, _: Bool) in
                            component.disruptions = self.disruptions
                        }),
                        ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                            component.styles = self.causeStyles
                            component.text = disruption.cause!
                        })
                    ])
            })
        }

        let containerStyles: [String: Any] = [
            "alignItems": YGAlign.center,
            "flexDirection": YGFlexDirection.row,
        ]
        let causeStyles: [String: Any] = [
            "fontSize": 15,
            "marginRight": 5,
        ]
    }
}
