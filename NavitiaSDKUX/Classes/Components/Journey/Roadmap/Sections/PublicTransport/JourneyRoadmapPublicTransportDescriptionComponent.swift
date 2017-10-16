import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.PublicTransport {
    class DescriptionComponent: ViewComponent {
        let SectionRowLayoutComponent = Components.Journey.Roadmap.Sections.SectionRowLayoutComponent.self
        let ModeIconComponent = Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent.self
        let ModeLineLabelComponent = Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeLineLabelComponent.self
        let DirectionComponent = Components.Journey.Roadmap.Sections.PublicTransport.Description.DirectionComponent.self
        
        var section: Section?

        override func render() -> NodeType {
            return ComponentNode(SectionRowLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionRowLayoutComponent, hasKey: Bool) in
                component.firstComponent = ComponentNode(self.ModeIconComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent, hasKey: Bool) in
                    component.section = self.section
                })
                component.thirdComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.containerStyles
                }).add(children: [
                    ComponentNode(self.ModeLineLabelComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeLineLabelComponent, hasKey: Bool) in
                        component.section = self.section
                    }),
                    ComponentNode(self.DirectionComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Description.DirectionComponent, hasKey: Bool) in
                        component.section = self.section
                    }),
                ])
            })
        }

        let containerStyles: [String: Any] = [
            "backgroundColor": UIColor.white,
            "paddingHorizontal": 5,
            "paddingTop": 14,
            "paddingBottom": 18,
        ]
    }
}
