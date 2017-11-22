import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections {
    class WaitingComponent: ViewComponent {
        var section: Section?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "flexDirection": YGFlexDirection.row,
                    "paddingVertical": 14,
                ]
            }).add(children: [
                ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, hasKey: Bool) in
                    component.styles = [
                        "width": 50,
                        "alignItems": YGAlign.center,
                        "justifyContent": YGJustify.center,
                    ]
                }).add(children: [
                    ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, hasKey: Bool) in
                        component.name = "clock"
                        component.styles = [
                            "color": getUIColorFromHexadecimal(hex: "666666"),
                            "fontSize": 20,
                        ]
                    })
                ]),
                ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, hasKey: Bool) in
                    component.styles = [
                        "flexGrow": 1,
                        "paddingStart": 6,
                        "flexDirection": YGFlexDirection.column,
                    ]
                }).add(children: [
                    ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, hasKey: Bool) in
                        component.styles = [
                            "flexGrow": 1,
                        ]
                    }),
                    ComponentNode(TextComponent(), in: self, props: {(component: TextComponent, hasKey: Bool) in
                        let durationInMinutes: Int = Int.init(self.section!.duration! / 60)
                        let unit: String = NSLocalizedString("units.minute\((durationInMinutes > 1) ? ".plural" : "")",
                            bundle: self.bundle,
                            comment: "Unit for waiting duration"
                        )
                        let action: String = NSLocalizedString("journey.roadmap.action.wait",
                            bundle: self.bundle,
                            comment: "Action description"
                        )
                        component.text = "\(durationInMinutes) \(unit) \(action)"
                    }),
                    ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, hasKey: Bool) in
                        component.styles = [
                            "flexGrow": 1,
                        ]
                    }),
                ])
            ])
        }
    }
}
