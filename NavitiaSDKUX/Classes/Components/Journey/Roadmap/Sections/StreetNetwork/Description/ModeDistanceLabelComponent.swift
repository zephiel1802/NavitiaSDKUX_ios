import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.StreetNetwork {
    class ModeDistanceLabelComponent: ViewComponent {
        var section: Section?
        
        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.containerStyles
            }).add(children: [
                ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                    component.styles = self.labelStyles
                    component.text = self.getDistanceLabel(section: self.section!)
                }),
            ])
        }
        
        func getDistanceLabel(section: Section) -> String {
            var distanceLabel: String = distanceText(meters: sectionLength(paths: section.path!))
            switch section.mode! {
            case "walking":
                distanceLabel += " " + NSLocalizedString("component.JourneyRoadmapSectionStreetNetworkDescriptionModeDistanceLabelComponent.mode.walking",
                                                         bundle: self.bundle,
                                                         comment: "StreetNetwork distance label for walking")
                break
            case "bike":
                distanceLabel += " " + NSLocalizedString("component.JourneyRoadmapSectionStreetNetworkDescriptionModeDistanceLabelComponent.mode.bike",
                                                         bundle: self.bundle,
                                                         comment: "StreetNetwork distance label for bike")
                break
            case "car":
                distanceLabel += " " + NSLocalizedString("component.JourneyRoadmapSectionStreetNetworkDescriptionModeDistanceLabelComponent.mode.car",
                                                         bundle: self.bundle,
                                                         comment: "StreetNetwork distance label for car")
                break
            case "bss":
                distanceLabel += " " + NSLocalizedString("component.JourneyRoadmapSectionStreetNetworkDescriptionModeDistanceLabelComponent.mode.bss",
                                                         bundle: self.bundle,
                                                         comment: "StreetNetwork distance label for bss")
                break
            default:
                break
            }
            return distanceLabel
        }
        
        let containerStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
            "paddingTop": 14,
            "paddingBottom": 18,
        ]
        let labelStyles: [String: Any] = [
            "fontSize": 15,
            "marginRight": 5,
        ]
    }
}
