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
                    "marginTop": 12
                ]
            }).add(children: [
                ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, hasKey: Bool) in
                    component.name = "clock"
                    component.styles = [
                        "color": getUIColorFromHexadecimal(hex: "666666"),
                        "fontSize": 18,
                    ]
                }),
                ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, hasKey: Bool) in
                    component.styles = [
                        "flexGrow": 1,
                        "marginLeft": 3
                    ]
                }).add(children: [
                    ComponentNode(TextComponent(), in: self, props: {(component: TextComponent, hasKey: Bool) in
                        let action: String = NSLocalizedString("journey.roadmap.action.wait",
                            bundle: self.bundle,
                            comment: "Action description"
                        )
                        component.text = "\(action) \(durationText(bundle: self.bundle, seconds: self.section!.duration!, useFullFormat: true))"
                    }),
                ])
            ])
        }
    }
}
