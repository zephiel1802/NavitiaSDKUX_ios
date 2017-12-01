import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.PublicTransport.Description {
    class DisruptionDescription: ViewComponent {
        var section: Section?
        var disruptions: [Disruption]?
        let modes: Modes = Modes()

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.containerStyles
            }).add(children: [
                ComponentNode(DisruptionBadgeComponent(), in: self, props: { (component: DisruptionBadgeComponent, _: Bool) in
                    component.disruptions = self.disruptions
                }),
                ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                    component.styles = self.modeStyles
                    component.text = self.modes.getPhysicalMode(section: self.section)
                }),
                ComponentNode(LineCodeWithDisruptionStatus(), in: self, props: { (component: LineCodeWithDisruptionStatus, hasKey: Bool) in
                    component.section = self.section
                    component.disruptions = self.disruptions
                })
            ])
        }

        let containerStyles: [String: Any] = [
            "alignItems": YGAlign.center,
            "flexDirection": YGFlexDirection.row,
        ]
        let modeStyles: [String: Any] = [
            "fontSize": 15,
            "marginRight": 5,
        ]
    }
}
