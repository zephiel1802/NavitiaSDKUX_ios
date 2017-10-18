import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.Transfer {
    class DescriptionComponent: ViewComponent {
        let SectionRowLayoutComponent:Components.Journey.Roadmap.Sections.SectionRowLayoutComponent.Type = Components.Journey.Roadmap.Sections.SectionRowLayoutComponent.self
        let ModeIconComponent:Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent.self
        let ModeDistanceLabelComponent:Components.Journey.Roadmap.Sections.Transfer.ModeDistanceLabelComponent.Type = Components.Journey.Roadmap.Sections.Transfer.ModeDistanceLabelComponent.self
        
        var section: Section?

        override func render() -> NodeType {
            return ComponentNode(self.SectionRowLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionRowLayoutComponent, hasKey: Bool) in
                component.styles = self.containerStyles
                component.firstComponent = ComponentNode(self.ModeIconComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent, hasKey: Bool) in
                    component.section = self.section
                })
                component.thirdComponent = ComponentNode(self.ModeDistanceLabelComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.Transfer.ModeDistanceLabelComponent, hasKey: Bool) in
                    component.section = self.section
                })
            })
        }

        let containerStyles: [String: Any] = [
            "paddingHorizontal": 4,
            "paddingVertical": 24,
        ]
    }
}
