import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.Details {
    class DetailButtonPart: ViewComponent {
        var color: UIColor?
        var collapsed: Bool = true
        var text: String!
        
        required init() {
            super.init()
            text = NSLocalizedString("component.JourneyRoadmapSectionPublicTransportDescriptionComponent.detailsHeaderTitle",
                                     bundle: self.bundle,
                                     comment: "Details header title for journey roadmap section")
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, _) in
                component.styles = self.detailsHeaderContainerStyle
            }).add(children: [
                ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, _) in
                    component.styles = self.detailsHeaderTitleStyle
                    component.text = self.text
                }),
                ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, _) in
                    component.styles = self.collapserWayIconStyle
                    component.name = self.collapsed ? "arrow-details-down" : "arrow-details-up"
                })
            ])
        }

        let detailsHeaderContainerStyle: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
            "paddingHorizontal": config.metrics.marginS,
            "alignItems": YGAlign.center
        ]
        let collapserWayIconStyle: [String: Any] = [
            "color": UIColor.lightGray,
            "fontSize": config.metrics.textS,
            "marginRight": config.metrics.marginS,
        ]
        let detailsHeaderTitleStyle: [String: Any] = [
            "color": UIColor.lightGray,
            "fontSize": config.metrics.textS,
            "marginRight": config.metrics.marginS,
        ]
    }
}
