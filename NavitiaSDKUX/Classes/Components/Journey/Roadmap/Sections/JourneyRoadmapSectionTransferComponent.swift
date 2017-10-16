import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections {
    class TransferComponent: ViewComponent {
        let DottedComponent = Components.Journey.Roadmap.Sections.LineDiagram.DottedComponent.self
        let SectionLayoutComponent = Components.Journey.Roadmap.Sections.SectionLayoutComponent.self
        let StopPointComponent = Components.Journey.Roadmap.Sections.StopPointComponent.self
        let DescriptionComponent = Components.Journey.Roadmap.Sections.Transfer.DescriptionComponent.self
        
        var section: Section?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self).add(children: [
                ComponentNode(self.DottedComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.LineDiagram.DottedComponent, hasKey: Bool) in
                    component.color = getUIColorFromHexadecimal(hex: "888888")
                }),
                ComponentNode(self.SectionLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionLayoutComponent, hasKey: Bool) in
                    component.header = ComponentNode(self.StopPointComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.StopPointComponent, hasKey: Bool) in
                        component.section = self.section
                        component.sectionWay = SectionWay.departure
                    })
                    component.body = ComponentNode(self.DescriptionComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.Transfer.DescriptionComponent, hasKey: Bool) in
                        component.section = self.section
                    })
                    component.footer = ComponentNode(self.StopPointComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.StopPointComponent, hasKey: Bool) in
                        component.section = self.section
                        component.sectionWay = SectionWay.arrival
                    })
                }),
            ])
        }
    }
}
