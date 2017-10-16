import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap {
    class SectionComponent: ViewComponent {
        let PublicTransportComponent = Components.Journey.Roadmap.Sections.PublicTransportComponent.self
        let TransferComponent = Components.Journey.Roadmap.Sections.TransferComponent.self
        let DefaultComponent = Components.Journey.Roadmap.Sections.DefaultComponent.self
        
        var section: Section?
        
        override func render() -> NodeType {
            switch self.section!.type! {
            case "public_transport":
                return ComponentNode(self.PublicTransportComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransportComponent, hasKey: Bool) in
                    component.section = self.section
                })
            case "transfer":
                return ComponentNode(self.TransferComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.TransferComponent, hasKey: Bool) in
                    component.section = self.section
                })
            default:
                return ComponentNode(self.DefaultComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.DefaultComponent, hasKey: Bool) in
                    component.section = self.section
                })
            }
        }
    }
}
