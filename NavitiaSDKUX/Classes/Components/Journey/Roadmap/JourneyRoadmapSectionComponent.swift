import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap {
    class SectionComponent: ViewComponent {
        let PublicTransportComponent:Components.Journey.Roadmap.Sections.PublicTransportComponent.Type = Components.Journey.Roadmap.Sections.PublicTransportComponent.self
        let StreetNetworkComponent:Components.Journey.Roadmap.Sections.StreetNetworkComponent.Type = Components.Journey.Roadmap.Sections.StreetNetworkComponent.self
        let TransferComponent:Components.Journey.Roadmap.Sections.TransferComponent.Type = Components.Journey.Roadmap.Sections.TransferComponent.self
        let DefaultComponent:Components.Journey.Roadmap.Sections.DefaultComponent.Type = Components.Journey.Roadmap.Sections.DefaultComponent.self
        
        var section: Section?
        var disruptions: [Disruption]?
        var destinationSection: Section?
        var departureTime: String?
        var arrivalTime: String?
        var label: String?
        var waitingSection: Section?
        
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
                return ComponentNode(PublicTransportComponent.init(),
                    in: self,
                    key: "\(String(describing: type(of: self)))_\(self.section!.type!)_\(self.section!.departureDateTime!)",
                    props: { (component: Components.Journey.Roadmap.Sections.PublicTransportComponent, _) in
                        component.section = self.section
                        component.disruptions = section.getMatchingDisruptions(from: self.disruptions, for: nil)
                        if self.waitingSection != nil {
                            component.waitingSection = self.waitingSection
                        }
                    })
            case "street_network":
                return ComponentNode(StreetNetworkComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.StreetNetworkComponent, _) in
                    component.section = self.section
                    component.label = self.label
                    component.departureTime = self.departureTime
                    component.arrivalTime = self.arrivalTime
                })
            case "transfer":
                return ComponentNode(TransferComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.TransferComponent, _) in
                    component.section = self.section
                    component.waitingSection = self.destinationSection
                })
            default:
                return ComponentNode(DefaultComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.DefaultComponent, _) in
                    component.section = self.section
                })
            }
        }
        
        let containerStyles: [String: Any] = [
            "backgroundColor": UIColor.white,
            "paddingVertical": 4,
            "paddingHorizontal": 4,
            "marginBottom": config.metrics.margin,
        ]
    }
}
