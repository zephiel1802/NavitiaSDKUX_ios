import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.LineDiagram {
    class PlainComponent: ViewComponent {
        var color: UIColor?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                self.lineDiagramStyle["backgroundColor"] = self.color!
                component.styles = self.lineDiagramStyle
            })
        }

        var lineDiagramStyle: [String: Any] = [
            "start": 58,
            "width": 4,
            "top": 16,
            "bottom": 16,
            "position": YGPositionType.absolute,
        ]
    }
}
