import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.StreetNetwork {
    class DescriptionComponent: ViewComponent {
        let SectionRowLayoutComponent:Components.Journey.Roadmap.Sections.SectionRowLayoutComponent.Type = Components.Journey.Roadmap.Sections.SectionRowLayoutComponent.self
        let ModeIconComponent:Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent.self
        
        var section: Section?
        
        override func render() -> NodeType {
            return ComponentNode(self.SectionRowLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionRowLayoutComponent, _) in
                component.styles = self.containerStyles
                component.firstComponent = ComponentNode(self.ModeIconComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent, _) in
                    component.section = self.section
                })
                component.thirdComponent = ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, _) in
                    component.text = self.getDistanceLabel(mode: (self.section?.mode)!, paths: (self.section?.path)!)
                })
            })
        }
        
        func getDistanceLabel(mode: String, paths: [Path]) -> String {
            var distanceLabel: String = distanceText(meters: sectionLength(paths: paths))
            switch mode {
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
            "paddingHorizontal": 4,
            "paddingVertical": 24,
        ]
        let labelStyles: [String: Any] = [
            "fontSize": 15,
            "marginRight": 5,
        ]
    }
}
