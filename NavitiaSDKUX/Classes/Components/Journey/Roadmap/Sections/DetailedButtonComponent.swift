import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections {
    class DetailedButtonComponent: ViewComponent {
        let SectionLayoutComponent = Components.Journey.Roadmap.Sections.SectionLayoutComponent.self
        
        var color: UIColor?
        var collapsed: Bool = true

        override func render() -> NodeType {
            return ComponentNode(self.SectionLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionLayoutComponent, hasKey: Bool) in
                component.styles = self.styles

                component.header = ComponentNode(ViewComponent(), in: self)

                /*
                component.body = ComponentNode(LineDiagramComponent(), in: self, props: { (component: LineDiagramComponent, hasKey: Bool) in
                    component.color = self.color
                })
                */

                component.footer = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.detailsHeaderContainerStyle
                }).add(children: [
                    ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, hasKey: Bool) in
                        component.styles = self.collapserWayIconStyle
                        component.name = self.collapsed ? "arrow-details-down" : "arrow-details-up"
                    }),
                    ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                        component.styles = self.detailsHeaderTitleStyle
                        component.text = NSLocalizedString("component.JourneyRoadmapSectionPublicTransportDescriptionComponent.detailsHeaderTitle",
                                bundle: self.bundle,
                                comment: "Details header title for journey roadmap section"
                        )
                    })
                ])
            })
        }

        let detailsHeaderContainerStyle: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
            "backgroundColor": UIColor.white,
            "paddingHorizontal": 5,
            "paddingTop": 0,
            "paddingBottom": 5,
        ]
        let collapserWayIconStyle: [String: Any] = [
            "color": UIColor.lightGray,
            "fontSize": 12,
            "marginRight": 5,
        ]
        let detailsHeaderTitleStyle: [String: Any] = [
            "color": UIColor.lightGray,
            "fontSize": 13,
            "marginRight": 5,
        ]
    }
}
