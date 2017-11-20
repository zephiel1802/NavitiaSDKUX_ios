import Render
import NavitiaSDK

class DisruptionBadgeComponent: ViewComponent {
    var disruptions: [Disruption]?

    override func render() -> NodeType {
        var highestDisruptionLevel = Disruption.DisruptionLevel.none
        if disruptions != nil {
            highestDisruptionLevel = getHighestLevelFrom(disruptions: disruptions!)
        }
        
        iconStyles["color"] = getUIColorFromHexadecimal(hex: getColorOf(disruptionLevel: highestDisruptionLevel))
        
        return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, _) in
            component.styles = self.containerStyles
        }).add(children: [
            ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, _) in
                component.name = "circle-filled"
                component.styles = self.edgeStyle
            }),
            ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, _) in
                component.name = "disruption-" + getStringOf(disruptionLevel: highestDisruptionLevel)
                component.styles = self.iconStyles
            }),
        ])
    }

    let containerStyles: [String: Any] = [
        "position": YGPositionType.absolute,
        "end": -11,
        "top": -9,
    ]
    let edgeStyle: [String: Any] = [
        "color": UIColor.white,
        "fontSize": 18,
    ]
    var iconStyles: [String: Any] = [
        "position": YGPositionType.absolute,
        "end": 0,
        "top": 0,
        "fontSize": 16,
    ]
}
