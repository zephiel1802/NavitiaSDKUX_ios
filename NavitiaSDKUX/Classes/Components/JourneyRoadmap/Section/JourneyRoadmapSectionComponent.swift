import Foundation
import Render
import NavitiaSDK

class JourneyRoadmapSectionComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        switch self.section!.type! {
        case "transfer":
            return ComponentNode(JourneyRoadmapSectionTransferComponent(), in: self, props: { (component: JourneyRoadmapSectionTransferComponent, hasKey: Bool) in
                component.section = self.section
            })
        case "public_transport":
            return ComponentNode(JourneyRoadmapSectionPublicTransportComponent(), in: self, props: { (component: JourneyRoadmapSectionPublicTransportComponent, hasKey: Bool) in
                component.section = self.section
            })
        default:
            return ComponentNode(JourneyRoadmapSectionDefaultComponent(), in: self, props: { (component: JourneyRoadmapSectionDefaultComponent, hasKey: Bool) in
                component.section = self.section
            })
        }
    }
}
