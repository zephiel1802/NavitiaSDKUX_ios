import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.PublicTransport.Description {
    class ModeLineLabelComponent: ViewComponent {
        var section: Section?
        let modes = Modes()

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.containerStyles
            }).add(children: [
                ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                    component.styles = self.modeStyles
                    component.text = self.modes.getPhysicalMode(section: self.section)
                }),
                ComponentNode(LineCodeComponent(), in: self, props: { (component: LineCodeComponent, hasKey: Bool) in
                    component.section = self.section
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
