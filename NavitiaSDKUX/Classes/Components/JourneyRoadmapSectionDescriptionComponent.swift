import Foundation
import Render
import NavitiaSDK

class JourneyRoadmapSectionDescriptionComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        let computedStyles = self.styles
        return ComponentNode(JourneyRoadmapSectionLayoutComponent(), in: self, props: { (component, hasKey: Bool) in
            component.styles = computedStyles

            component.firstComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": UIColor.white,
                    "flexGrow": 1,
                    "alignItems": YGAlign.center,
                ]
            }).add(children: [
                ComponentNode(ModeComponent(), in: self, props: {(component: ModeComponent, hasKey: Bool) in
                    component.name = self.getModeIcon(section: self.section!)
                    component.styles = [
                        "height": 28,
                    ]
                })
            ])

            component.secondComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": getUIColorFromHexadecimal(hex: (self.section!.displayInformations?.color)!),
                    "flexGrow": 1,
                ]
            })

            component.thirdComponent = ComponentNode(LabelComponent(), in: self).add(children: [
                ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                    component.text = "DESCRIPTION"
                })
            ])
        })
    }

    func getModeIcon(section: Section) -> String {
        switch section.type! {
        case "public_transport": return getPhysicalMode(links: section.links!)
        case "transfer": return section.transferType!
        case "waiting": return section.type!
        default: return section.mode!
        }
    }

    func getPhysicalMode(links: [LinkSchema]) -> String {
        let id = getPhysicalModeId(links: links)
        var modeData = id.characters.split(separator: ":").map(String.init)
        return modeData[1].lowercased()
    }

    func getPhysicalModeId(links: [LinkSchema]) -> String {
        for link in links {
            if link.type == "physical_mode" {
                return link.id!
            }
        }
        return "<not_found>"
    }
}
