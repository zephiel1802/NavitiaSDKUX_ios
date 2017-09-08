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

            component.secondComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": getUIColorFromHexadecimal(hex: (self.section!.displayInformations?.color)!),
                    "flexGrow": 1,
                ]
            })

            component.thirdComponent = ComponentNode(LabelComponent(), in: self).add(children: [
                ComponentNode(LabelComponent(), in: self, props: { (component, hasKey: Bool) in
                    component.text = "DESCRIPTION"
                })
            ])
        })
    }
}
