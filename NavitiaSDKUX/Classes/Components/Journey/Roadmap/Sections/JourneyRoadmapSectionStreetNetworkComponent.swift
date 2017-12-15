import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections {
    class StreetNetworkComponent: ViewComponent {
        let DottedComponent:Components.Journey.Roadmap.Sections.LineDiagram.DottedComponent.Type = Components.Journey.Roadmap.Sections.LineDiagram.DottedComponent.self
        let SectionLayoutComponent:Components.Journey.Roadmap.Sections.SectionLayoutComponent.Type = Components.Journey.Roadmap.Sections.SectionLayoutComponent.self
        let StopPointComponent:Components.Journey.Roadmap.Sections.StopPointComponent.Type = Components.Journey.Roadmap.Sections.StopPointComponent.self
        let DescriptionComponent:Components.Journey.Roadmap.Sections.StreetNetwork.DescriptionComponent.Type = Components.Journey.Roadmap.Sections.StreetNetwork.DescriptionComponent.self
        
        var section: Section?
        var departureTime: String?
        var arrivalTime: String?
        var label: String?
        
        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props:{(component: ViewComponent, hasKey: Bool) in
                component.styles = self.containerStyles
            }).add(children: [
                ComponentNode(self.DottedComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.LineDiagram.DottedComponent, _) in
                    component.color = config.colors.gray
                }),
                ComponentNode(self.SectionLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionLayoutComponent, _) in
                    component.header = ComponentNode(self.StopPointComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.StopPointComponent, _) in
                        component.section = self.section
                        component.sectionWay = SectionWay.departure
                        component.color = config.colors.gray
                        component.time = self.departureTime
                    })
                    component.body = ComponentNode(ViewComponent(), in: self).add(children: [
                        ComponentNode(self.DescriptionComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.StreetNetwork.DescriptionComponent, _) in
                            component.section = self.section
                            component.label = self.label
                        })
                    ])
                    component.footer = ComponentNode(self.StopPointComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.StopPointComponent, _) in
                        component.section = self.section
                        component.sectionWay = SectionWay.arrival
                        component.color = config.colors.gray
                        component.time = self.arrivalTime
                    })
                }),
            ])
        }
        
        let containerStyles: [String : Any] = [
            "paddingVertical" : 12
        ]
    }
}
