import Render
import NavitiaSDK

class DisruptionBadgeComponent: ViewComponent {
    var disruptions: [Disruption]?

    override func render() -> NodeType {
        var highestDisruptionLevel = Disruption.DisruptionLevel.none
        if disruptions != nil && disruptions!.count > 0 {
            highestDisruptionLevel = Disruption.getHighestLevelFrom(disruptions: disruptions!)
        }
        
        iconStyles["color"] = getUIColorFromHexadecimal(hex: Disruption.getLevelColor(of: highestDisruptionLevel))
        
        return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, _) in
            component.styles = self.styles
        }).add(children: [
            ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, _) in
                component.name = "circle-filled"
                component.styles = self.edgeStyle
            }),
            ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, _) in
                component.name = Disruption.getIconName(of: highestDisruptionLevel)
                component.styles = self.iconStyles
            }),
        ])
    }

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
