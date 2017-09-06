import Foundation
import Render
import NavitiaSDK

class JourneyRoadmapSectionComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        switch self.section!.type! {
        case "public_transport":
            return ComponentNode(JourneyRoadmapSectionPublicTransportComponent(), in: self, props: { (component, hasKey: Bool) in
                component.section = self.section
            })
        default:
            return ComponentNode(JourneyRoadmapSectionDefaultComponent(), in: self, props: { (component, hasKey: Bool) in
                component.section = self.section
            })
        }
    }
}
