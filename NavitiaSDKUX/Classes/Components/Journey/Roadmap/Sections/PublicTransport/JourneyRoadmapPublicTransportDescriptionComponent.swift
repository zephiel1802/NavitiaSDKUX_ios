import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.PublicTransport {
    class DescriptionComponent: ViewComponent {
        let SectionRowLayoutComponent:Components.Journey.Roadmap.Sections.SectionRowLayoutComponent.Type = Components.Journey.Roadmap.Sections.SectionRowLayoutComponent.self
        let DirectionComponent:Components.Journey.Roadmap.Sections.PublicTransport.Description.DirectionComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.Description.DirectionComponent.self

        var section: Section?
        var disruptions: [Disruption]?

        override func render() -> NodeType {
            return ComponentNode(SectionRowLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionRowLayoutComponent, hasKey: Bool) in
                component.thirdComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.containerStyles
                }).add(children: [
                    ComponentNode(self.DirectionComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Description.DirectionComponent, hasKey: Bool) in
                        component.section = self.section
                    })
                ])
            })
        }

        let containerStyles: [String: Any] = [
            "paddingHorizontal": 4,
            "paddingVertical": 14,
        ]
    }
}
