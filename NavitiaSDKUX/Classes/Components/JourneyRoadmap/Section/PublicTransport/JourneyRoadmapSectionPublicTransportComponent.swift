import Foundation
import Render
import NavitiaSDK

class JourneyRoadmapSectionPublicTransportComponent: ViewComponent {
    var section: Section?

    public required init() {
        super.init()
        NSLog("#SCREEN level 2# JourneyRoadmapSectionPublicTransportComponent init")
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func render() -> NodeType {
        NSLog("#SCREEN level 2# JourneyRoadmapSectionPublicTransportComponent \(self.section!.displayInformations!.label!) \(String(describing: type(of: self)))_\(self.section!.type!)_\(self.section!.departureDateTime!)")
        return ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
            component.styles = self.sectionStyles
        }).add(children: [
            ComponentNode(JourneyRoadmapSectionPublicTransportStopPointComponent(), in: self, props: { (component: JourneyRoadmapSectionPublicTransportStopPointComponent, hasKey: Bool) in
                component.section = self.section
                component.sectionWay = SectionWay.departure
            }),
            ComponentNode(JourneyRoadmapSectionPublicTransportDescriptionComponent(),
                    in: self,
                    key: "\(String(describing: type(of: self)))_\(self.section!.type!)_\(self.section!.departureDateTime!)",
                    props: { (component: JourneyRoadmapSectionPublicTransportDescriptionComponent, hasKey: Bool) in
                        component.section = self.section
                    }),
            ComponentNode(JourneyRoadmapSectionPublicTransportStopPointComponent(), in: self, props: { (component: JourneyRoadmapSectionPublicTransportStopPointComponent, hasKey: Bool) in
                component.section = self.section
                component.sectionWay = SectionWay.arrival
            })
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
