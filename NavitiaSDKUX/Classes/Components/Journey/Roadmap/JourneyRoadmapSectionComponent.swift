import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap {
    class SectionComponent: ViewComponent {
        let PublicTransportComponent = Components.Journey.Roadmap.Sections.PublicTransportComponent.self
        let TransferComponent = Components.Journey.Roadmap.Sections.TransferComponent.self
        let DefaultComponent = Components.Journey.Roadmap.Sections.DefaultComponent.self
        
        var section: Section?
        var destinationSection: Section?
        
        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, _) in
                component.styles = self.containerStyles
            }).add(children: [
                getTypedSectionComponent(section: section!)
            ])
        }
        
        func getTypedSectionComponent(section: Section) -> NodeType {
            switch self.section!.type! {
            case "public_transport":
                return ComponentNode(self.PublicTransportComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransportComponent, hasKey: Bool) in
                    component.section = self.section
                })
            case "transfer":
                return ComponentNode(self.TransferComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.TransferComponent, hasKey: Bool) in
                    component.section = self.section
                    component.waitingSection = self.destinationSection
                })
            default:
                return ComponentNode(self.DefaultComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.DefaultComponent, hasKey: Bool) in
                    component.section = self.section
                })
            }
        }
        
        let containerStyles: [String: Any] = [
            "backgroundColor": UIColor.white,
            "paddingTop": 4,
            "marginBottom": config.metrics.margin,
        ]
    }
}
