import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.LineDiagram {
    class PlainComponent: ViewComponent {
        var color: UIColor?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.lineDiagramContainerStyle
            }).add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.lineDiagramStyle
                    component.styles["backgroundColor"] = self.color!
                })
            ])
        }

        let lineDiagramContainerStyle: [String: Any] = [
            "backgroundColor": UIColor.white,
            "flexGrow": 1,
            "alignItems": YGAlign.center,
        ]
        var lineDiagramStyle: [String: Any] = [
            "flexGrow": 1,
            "width": 4,
        ]
    }
}
