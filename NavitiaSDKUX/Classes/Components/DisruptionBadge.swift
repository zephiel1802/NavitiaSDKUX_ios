import Render
import NavitiaSDK

class DisruptionBadge: ViewComponent {
    var disruptions: [Disruption]?

    override func render() -> NodeType {
        return ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, _) in
            component.name = "circle-filled"
            component.styles = self.disruptionBadgeStyle
        })
    }

    let disruptionBadgeStyle: [String: Any] = [
        "position": YGPositionType.absolute,
        "end": -11,
        "top": -9,
        "color": UIColor.red,
        "fontSize": 18,
    ]
}
