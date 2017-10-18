import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections {
    class PublicTransportComponent: ViewComponent {
        let SectionLayoutComponent = Components.Journey.Roadmap.Sections.SectionLayoutComponent.self
        let PlainComponent = Components.Journey.Roadmap.Sections.LineDiagram.PlainComponent.self
        let StopPointComponent = Components.Journey.Roadmap.Sections.StopPointComponent.self
        let DescriptionComponent = Components.Journey.Roadmap.Sections.PublicTransport.DescriptionComponent.self
        let DetailsComponent = Components.Journey.Roadmap.Sections.PublicTransport.DetailsComponent.self
        
        var section: Section?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self).add(children: [
                ComponentNode(self.PlainComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.LineDiagram.PlainComponent, hasKey: Bool) in
                    component.color = getUIColorFromHexadecimal(hex: (self.section?.displayInformations?.color)!)
                }),
                ComponentNode(self.SectionLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionLayoutComponent, hasKey: Bool) in
                    component.header = ComponentNode(self.StopPointComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.StopPointComponent, hasKey: Bool) in
                        component.section = self.section
                        component.sectionWay = SectionWay.departure
                    })
                    component.body = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                        component.styles = self.bodyContainerStyles
                    }).add(children: [
                        ComponentNode(self.DescriptionComponent.init(),
                            in: self,
                            props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.DescriptionComponent, hasKey: Bool) in
                                component.section = self.section
                            }),
                        ComponentNode(self.DetailsComponent.init(),
                            in: self,
                            key: "\(String(describing: type(of: self)))_\(self.section!.type!)_\(self.section!.departureDateTime!)",
                            props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.DetailsComponent, hasKey: Bool) in
                                component.section = self.section
                            }),
                    ])
                    component.footer = ComponentNode(self.StopPointComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.StopPointComponent, hasKey: Bool) in
                        component.section = self.section
                        component.sectionWay = SectionWay.arrival
                    })
                }),
            ])
        }

        let bodyContainerStyles: [String: Any] = [
            "paddingVertical": 12,
            "paddingHorizontal": 0,
        ]
    }
}
