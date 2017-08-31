import Foundation
import Render
import NavitiaSDK

class JourneyRoadmapSectionComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        let sectionContainer: NodeType = ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
            component.styles = self.listStyles
        })

        sectionContainer.add(children: [ComponentNode(LabelComponent(), in: self, props: {(component: LabelComponent, hasKey: Bool) in
            if (self.section!.type != nil) {
                component.text = self.section!.type!
            }
        })])
        sectionContainer.add(children: [ComponentNode(SeparatorComponent(), in: self)])
        sectionContainer.add(children: [ComponentNode(LabelComponent(), in: self, props: {(component: LabelComponent, hasKey: Bool) in
            if (self.section!.departureDateTime != nil && self.section!.from != nil) {
                component.text = "\(timeText(isoString: self.section!.departureDateTime!)) : \(self.section!.from!.name!)"
            }
        })])
        sectionContainer.add(children: [ComponentNode(SeparatorComponent(), in: self)])
        sectionContainer.add(children: [ComponentNode(LabelComponent(), in: self, props: {(component: LabelComponent, hasKey: Bool) in
            if (self.section!.arrivalDateTime != nil && self.section!.to != nil) {
                component.text = "\(timeText(isoString: self.section!.arrivalDateTime!)) : \(self.section!.to!.name!)"
            }
        })])

        return sectionContainer
    }


    let listStyles:[String: Any] = [
        "backgroundColor": config.colors.white,
        "padding": config.metrics.marginL,
        "paddingTop": 4,
        "borderRadius": config.metrics.radius,
        "marginBottom": config.metrics.margin,
        "shadowRadius": CGFloat(2),
        "shadowOpacity": 0.12,
        "shadowOffset": [0, 0],
        "shadowColor": UIColor.black,
    ]
}
