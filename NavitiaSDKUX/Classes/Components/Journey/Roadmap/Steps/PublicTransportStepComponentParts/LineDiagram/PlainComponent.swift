import Foundation

extension Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.LineDiagram {
    class PlainPart: ViewComponent {
        var color: UIColor?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component, _) in
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
