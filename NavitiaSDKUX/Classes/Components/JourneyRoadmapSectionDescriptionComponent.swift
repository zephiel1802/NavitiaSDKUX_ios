import Foundation
import Render
import NavitiaSDK

class JourneyRoadmapSectionDescriptionComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        let computedStyles = self.styles
        return ComponentNode(JourneyRoadmapSectionLayoutComponent(), in: self, props: { (component, hasKey: Bool) in
            component.styles = computedStyles

            component.firstComponent = ComponentNode(LabelComponent(), in: self).add(children: [
                ComponentNode(LabelComponent(), in: self, props: { (component, hasKey: Bool) in
                    component.text = "Mode Icon"
                })
            ])
            component.secondComponent = ComponentNode(LabelComponent(), in: self, props: { (component, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": getUIColorFromHexadecimal(hex: (self.section!.displayInformations?.color)!),
                    "fontWeight": "bold",
                    "color": config.colors.white,
                ]

                component.text = "|"
            })
            component.thirdComponent = ComponentNode(LabelComponent(), in: self).add(children: [
                ComponentNode(LabelComponent(), in: self, props: { (component, hasKey: Bool) in
                    component.text = "DESCRIPTION"
                })
            ])
        })
    }
}
