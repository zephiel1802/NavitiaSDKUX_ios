import Foundation
import Render
import NavitiaSDK

class JourneyRoadmapSectionComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self, props: { (component, hasKey: Bool) in
            component.styles = self.sectionStyles
        }).add(children: [
            ComponentNode(LabelComponent(), in: self, props: {(component, hasKey: Bool) in
                if (self.section!.type != nil) {
                    component.text = self.section!.type!
                    component.styles = self.typeStyles
                }
            }),
            ComponentNode(SeparatorComponent(), in: self, props: {(component, hasKey: Bool) in
                component.styles = self.separatorStyles
            }),
            ComponentNode(LabelComponent(), in: self, props: {(component, hasKey: Bool) in
                if (self.section!.departureDateTime != nil && self.section!.from != nil) {
                    component.text = "\(timeText(isoString: self.section!.departureDateTime!)) : \(self.section!.from!.name!)"
                }
            }),
            ComponentNode(LabelComponent(), in: self, props: {(component, hasKey: Bool) in
                if (self.section!.arrivalDateTime != nil && self.section!.to != nil) {
                    component.text = "\(timeText(isoString: self.section!.arrivalDateTime!)) : \(self.section!.to!.name!)"
                }
            })
        ])
    }
    
    let sectionStyles:[String: Any] = [
        "backgroundColor": config.colors.white,
        "padding": config.metrics.marginL,
        "paddingTop": 0,
        "paddingBottom": 10,
        "borderRadius": config.metrics.radius,
        "marginBottom": config.metrics.margin,
        "shadowRadius": 0.2,
        "shadowOpacity": 0.12,
        "shadowOffset": [0, 0],
        "shadowColor": UIColor.black,
    ]

    let typeStyles:[String: Any] = [
        "fontWeight": "bold",
        "paddingTop": 6,
        "paddingBottom": 6,
    ]
    
    let separatorStyles:[String: Any] = [
        "marginBottom": 10,
    ]
}
