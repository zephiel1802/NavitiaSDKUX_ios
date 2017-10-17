import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.Transfer {
    class WaitingComponent: ViewComponent {
        let SectionRowLayoutComponent = Components.Journey.Roadmap.Sections.SectionRowLayoutComponent.self
        
        var section: Section?
        
        override func render() -> NodeType {
            return ComponentNode(self.SectionRowLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionRowLayoutComponent, _) in
                component.thirdComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, _) in
                    component.styles = self.containerStyles
                }).add(children: [
                    ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, _) in
                        let durationInMinutes: Int = Int.init(self.section!.duration! / 60)
                        let unit = NSLocalizedString("units.minute\((durationInMinutes > 1) ? ".plural" : "")",
                            bundle: self.bundle,
                            comment: "Unit for waiting duration"
                        )
                        let action = NSLocalizedString("journey.roadmap.action.wait",
                            bundle: self.bundle,
                            comment: "Action description"
                        )
                        component.text = "\(durationInMinutes) \(unit) \(action)"
                    })
                ])
            })
        }
        
        let containerStyles: [String: Any] = [
            "backgroundColor": config.colors.lighterGray,
            "paddingHorizontal": 4,
            "paddingTop": 14,
            "paddingBottom": 0,
        ]
    }
}
