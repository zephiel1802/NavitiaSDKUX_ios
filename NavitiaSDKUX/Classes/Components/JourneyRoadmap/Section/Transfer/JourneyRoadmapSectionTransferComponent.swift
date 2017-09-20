import Foundation
import Render
import NavitiaSDK

class JourneyRoadmapSectionTransferComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
            component.styles = self.sectionStyles
        }).add(children: [
//            ComponentNode(JourneyRoadmapSectionStopPointComponent(), in: self, props: { (component: JourneyRoadmapSectionStopPointComponent, hasKey: Bool) in
//                component.section = self.section
//                component.sectionWay = SectionWay.departure
//            }),
//            ComponentNode(JourneyRoadmapSectionDescriptionComponent(), in: self, props: { (component: JourneyRoadmapSectionDescriptionComponent, hasKey: Bool) in
//                component.section = self.section
//            }),
//            ComponentNode(JourneyRoadmapSectionStopPointComponent(), in: self, props: { (component: JourneyRoadmapSectionStopPointComponent, hasKey: Bool) in
//                component.section = self.section
//                component.sectionWay = SectionWay.arrival
//            })
        ])
    }

    let sectionStyles: [String: Any] = [
        "backgroundColor": config.colors.white,
        "padding": 0,
        "borderRadius": config.metrics.radius,
        "shadowRadius": 2.0,
        "shadowOpacity": 0.12,
        "shadowOffset": [0, 0],
        "shadowColor": UIColor.black,
        "marginBottom": config.metrics.margin,
    ]
}
