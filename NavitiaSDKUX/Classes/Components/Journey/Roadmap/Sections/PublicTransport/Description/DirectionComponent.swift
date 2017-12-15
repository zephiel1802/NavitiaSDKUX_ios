import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.PublicTransport.Description {
    class DirectionComponent: ViewComponent {
        var section: Section?
        var disruptions: [Disruption]?
        let modes:Modes = Modes()
        let ModeLineLabelComponent:Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeLineLabelComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeLineLabelComponent.self

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self).add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.containerStyles
                }).add(children: [
                    ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                        component.styles = self.textStyles
                        component.text = NSLocalizedString("component.JourneyRoadmapSectionPublicTransportComponent.DirectionComponent.take", bundle: self.bundle, comment: "PublicTransport description")
                    }),
                    ComponentNode(self.ModeLineLabelComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeLineLabelComponent, hasKey: Bool) in
                        component.styles = self.transportModeStyles
                        component.section = self.section
                        component.disruptions = self.disruptions
                    })
                ]),
                ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                    component.styles = self.textStyles
                    let localizedToResource = NSLocalizedString("component.JourneyRoadmapSectionPublicTransportComponent.DirectionComponent.at", bundle: self.bundle, comment: "PublicTransport description")
                    let localizedDirectionResource = NSLocalizedString("component.JourneyRoadmapSectionPublicTransportComponent.DirectionComponent.direction", bundle: self.bundle, comment: "PublicTransport description")
                    let fullDescriptionText = NSMutableAttributedString.init(string: "\(localizedToResource) \(self.section!.from!.name!)")
                    fullDescriptionText.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)], range: NSMakeRange(localizedToResource.count + 1, self.section!.from!.name!.count))
                    let tripDirectionText = NSMutableAttributedString.init(string: "\n\(localizedDirectionResource) \(self.section!.displayInformations!.direction!)")
                    tripDirectionText.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)], range: NSMakeRange(localizedDirectionResource.count + 1, self.section!.displayInformations!.direction!.count))
                    fullDescriptionText.append(tripDirectionText)
                    component.attributedText = fullDescriptionText
                })
            ])
        }
        let containerStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row
        ]
        let iconStyles: [String: Any] = [
            "marginRight": 5,
            "fontSize": 12,
        ]
        let textStyles: [String: Any] = [
            "fontSize": 15,
            "lineHeight": 6,
            "numberOfLines": 0
        ]
        let transportModeStyles: [String : Any] = [
            "marginLeft" : 2
        ]
    }
}
