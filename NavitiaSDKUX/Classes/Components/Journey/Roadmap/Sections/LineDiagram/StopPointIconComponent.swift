import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.LineDiagram {
    class StopPointIconComponent: ViewComponent {
        var color: UIColor?
        var sectionWay: SectionWay?

        override func render() -> NodeType {
            let subComponents = [
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.emptyComponentStyle
                }),
                /*
                ComponentNode(LineDiagramStopPointIconComponent(), in: self, props: { (component: LineDiagramStopPointIconComponent, hasKey: Bool) in
                    component.color = self.color
                    if (self.sectionWay != nil && self.sectionWay! == SectionWay.departure) {
                        component.hasUpperJunction = false
                        component.hasLowerJunction = true
                    }
                    if (self.sectionWay != nil && self.sectionWay! == SectionWay.arrival) {
                        component.hasUpperJunction = true
                        component.hasLowerJunction = false
                    }
                }),
                ComponentNode(SubLineDiagramComponent(), in: self, props: { (component: SubLineDiagramComponent, hasKey: Bool) in
                    component.color = self.color
                }),
                */
            ]

            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.lineDiagramContainerStyle
            }).add(children: sectionWay == SectionWay.departure ? subComponents : subComponents.reversed())
        }

        let lineDiagramContainerStyle: [String: Any] = [
            "flexGrow": 1,
            "alignItems": YGAlign.center,
            "justifyContent": YGJustify.center,
        ]
        let emptyComponentStyle: [String: Any] = [
            "flexGrow": 1,
        ]
    }
}
