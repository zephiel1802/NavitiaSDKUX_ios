import Foundation
import Render
import NavitiaSDK

class JourneyRoadmapSectionDescriptionComponent: ViewComponent {
    let modes = Modes()
    var section: Section?

    override func render() -> NodeType {
        let computedStyles = self.styles
        return ComponentNode(JourneyRoadmapSectionLayoutComponent(), in: self, props: { (component, hasKey: Bool) in
            component.styles = computedStyles

            component.firstComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": UIColor.white,
                    "flexGrow": 1,
                    "alignItems": YGAlign.center,
                ]
            }).add(children: [
                ComponentNode(ModeComponent(), in: self, props: {(component: ModeComponent, hasKey: Bool) in
                    component.styles = [
                        "height": 28,
                    ]

                    component.section = self.section
                })
            ])

            component.secondComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": getUIColorFromHexadecimal(hex: (self.section!.displayInformations?.color)!),
                    "flexGrow": 1,
                ]
            })

            // TODO : Adding LineComponent
            component.thirdComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": UIColor.white,
                    "paddingHorizontal": 5,
                    "paddingTop": 14,
                    "paddingBottom": 18,
                ]
            }).add(children: [
                ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, hasKey: Bool) in
                    component.styles = [
                        "flexDirection": YGFlexDirection.row,
                    ]
                }).add(children: [
                    ComponentNode(LabelComponent(), in: self, props: {(component: LabelComponent, hasKey: Bool) in
                        component.styles = [
                            "fontSize": 15,
                            "marginRight": 5,
                        ]

                        component.text = self.modes.getPhysicalMode(section: self.section)
                    }),
                    ComponentNode(LineCodeComponent(), in: self, props: {(component: LineCodeComponent, hasKey: Bool) in
                        component.section = self.section
                    })
                ])

            ])
        })
    }
}
