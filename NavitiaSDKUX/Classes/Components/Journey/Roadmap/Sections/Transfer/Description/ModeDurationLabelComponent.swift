import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.Transfer {
    class ModeDurationLabelComponent: ViewComponent {
        var section: Section?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.containerStyles
            }).add(children: [
                ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                    component.styles = self.labelStyles
                
                    let durationInMinutes: Int = Int.init(self.section!.duration! / 60)
                    let unit = NSLocalizedString("units.minute\((durationInMinutes > 1) ? ".plural" : "")",
                        bundle: self.bundle,
                        comment: "Unit for walking duration"
                    )
                    let action = NSLocalizedString("journey.roadmap.action.walk",
                        bundle: self.bundle,
                        comment: "Action description"
                    )
                    component.text = "\(durationInMinutes) \(unit) \(action)"
                }),
            ])
        }

        let containerStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
            "paddingTop": 14,
            "paddingBottom": 18,
        ]
        let labelStyles: [String: Any] = [
            "fontSize": 15,
            "marginRight": 5,
        ]
    }
}
