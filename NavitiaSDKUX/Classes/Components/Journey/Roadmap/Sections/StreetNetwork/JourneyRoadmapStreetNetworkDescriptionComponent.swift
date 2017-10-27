import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.StreetNetwork {
    class DescriptionComponent: ViewComponent {
        let SectionRowLayoutComponent:Components.Journey.Roadmap.Sections.SectionRowLayoutComponent.Type = Components.Journey.Roadmap.Sections.SectionRowLayoutComponent.self
        let ModeIconComponent:Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent.self
        
        var section: Section?
        var label: String?
        
        override func render() -> NodeType {
            return ComponentNode(self.SectionRowLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionRowLayoutComponent, _) in
                component.styles = self.containerStyles
                component.firstComponent = ComponentNode(self.ModeIconComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent, _) in
                    component.section = self.section
                })
                component.thirdComponent = ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, _) in
                    component.styles = self.labelStyles
                    component.text = self.label!
                })
            })
        }
        
        let containerStyles: [String: Any] = [
            "paddingHorizontal": 4,
            "paddingVertical": 24,
        ]
        let labelStyles: [String: Any] = [
            "fontSize": 15,
            "marginRight": 5,
        ]
    }
}
