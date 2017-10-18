import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.PublicTransport.Description {
    class DirectionComponent: ViewComponent {
        var section: Section?
        let modes:Modes = Modes()

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.containerStyles
            }).add(children: [
                ComponentNode(IconComponent(), in: self, props: { (component, hasKey: Bool) in
                    component.styles = self.iconStyles
                    component.name = "direction"
                }),
                ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                    component.styles = self.directionStyles
                    component.text = self.section!.displayInformations!.direction!
                })
            ])
        }

        let containerStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
        ]
        let iconStyles: [String: Any] = [
            "marginRight": 5,
            "fontSize": 12,
        ]
        let directionStyles: [String: Any] = [
            "fontSize": 15,
        ]
    }
}
