import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.PublicTransport.Description {
    class DirectionComponent: ViewComponent {
        var section: Section?
        let modes = Modes()

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.descriptionContainerStyle
            }).add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.modeContainerStyle
                }).add(children: [
                    ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                        component.styles = self.physicalModeLabelStyle
                        component.text = self.modes.getPhysicalMode(section: self.section)
                    }),
                    ComponentNode(LineCodeComponent(), in: self, props: { (component: LineCodeComponent, hasKey: Bool) in
                        component.section = self.section
                    })
                ]),
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.directionContainerStyle
                }).add(children: [
                    ComponentNode(IconComponent(), in: self, props: { (component, hasKey: Bool) in
                        component.name = "direction"
                        component.styles = self.directionIconStyle
                    }),
                    ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                        component.styles = self.directionLabelStyle
                        component.text = self.section!.displayInformations!.direction!
                    })
                ])
            ])
        }

        let descriptionContainerStyle: [String: Any] = [
            "backgroundColor": UIColor.white,
            "paddingHorizontal": 5,
            "paddingTop": 14,
            "paddingBottom": 18,
        ]
        let modeContainerStyle: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
        ]
        let physicalModeLabelStyle: [String: Any] = [
            "fontSize": 15,
            "marginRight": 5,
        ]
        let directionContainerStyle: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
        ]
        let directionIconStyle: [String: Any] = [
            "fontSize": 12,
            "marginRight": 5,
        ]
        let directionLabelStyle: [String: Any] = [
            "fontSize": 15,
            "numberOfLines": 0,
            "lineBreakMode": NSLineBreakMode.byWordWrapping,
            "flexShrink": 1,
        ]
    }
}
