import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts {
    class DirectionPart: ViewComponent {
        var section: Section?
        var disruptions: [Disruption]?
        let modes:Modes = Modes()

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self).add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, _) in
                    component.styles = self.modeLineLabelStyles
                }).add(children: [
                    ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, _) in
                        component.styles = mergeDictionaries(dict1: self.instructionTextStyles, dict2: self.modeStyles)
                        component.text = NSLocalizedString("component.JourneyRoadmapSectionPublicTransportComponent.DirectionComponent.take", bundle: self.bundle, comment: "PublicTransport description")
                    }),
                    ComponentNode(LineCodeWithDisruptionStatusComponent(), in: self, props: { (component: LineCodeWithDisruptionStatusComponent, _) in
                        component.section = self.section
                        component.disruptions = self.disruptions
                    })
                ]),
                ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, _) in
                    component.styles = self.instructionTextStyles
                    let localizedToResource = NSLocalizedString("component.JourneyRoadmapSectionPublicTransportComponent.DirectionComponent.at", bundle: self.bundle, comment: "PublicTransport description")
                    let localizedDirectionResource = NSLocalizedString("component.JourneyRoadmapSectionPublicTransportComponent.DirectionComponent.direction", bundle: self.bundle, comment: "PublicTransport description")
                    let fullDescriptionText = NSMutableAttributedString.init(string: "\(localizedToResource) \(self.section!.from!.name!)")
                    fullDescriptionText.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)], range: NSMakeRange(localizedToResource.characters.count + 1, self.section!.from!.name!.characters.count))
                    let tripDirectionText = NSMutableAttributedString.init(string: "\n\(localizedDirectionResource) \(self.section!.displayInformations!.direction!)")
                    tripDirectionText.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)], range: NSMakeRange(localizedDirectionResource.characters.count + 1, self.section!.displayInformations!.direction!.characters.count))
                    fullDescriptionText.append(tripDirectionText)
                    component.attributedText = fullDescriptionText
                })
            ])
        }
        let modeLineLabelStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
            "alignItems": YGAlign.center,
        ]

        let instructionTextStyles: [String: Any] = [
            "color": config.colors.darkText,
            "fontSize": config.metrics.text,
            "lineHeight": 6,
            "numberOfLines": 0,
        ]
        
        let modeStyles: [String: Any] = [
            "marginRight": 5,
        ]
    }
}
