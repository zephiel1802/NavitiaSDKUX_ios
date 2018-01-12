import Render
import NavitiaSDK

class LineCodeWithDisruptionStatusComponent: ViewComponent {
    let DisruptionBadgeComponent: Components.LineCodeWithDisruptionStatusComponentParts.DisruptionBadgeComponent.Type = Components.LineCodeWithDisruptionStatusComponentParts.DisruptionBadgeComponent.self
    let LineCodeComponent: Components.LineCodeWithDisruptionStatusComponentParts.LineCodeComponent.Type = Components.LineCodeWithDisruptionStatusComponentParts.LineCodeComponent.self
    
    var section: Section?
    var disruptions: [Disruption]?

    override func render() -> NodeType {
        var disruptionBadgeComponent: NodeType = ComponentNode(ViewComponent(), in: self)
        if disruptions != nil && disruptions!.count > 0 {
            let disruptionBadgeStyles: [String: Any] = [
                "position": YGPositionType.absolute,
                "end": -11,
                "top": -9,
            ]

            disruptionBadgeComponent = ComponentNode(self.DisruptionBadgeComponent.init(), in: self, props: { (component, _: Bool) in
                component.disruptions = self.disruptions
                component.styles = disruptionBadgeStyles
            })
        }
        
        return ComponentNode(ViewComponent(), in: self)
            .add(children: [
                ComponentNode(self.LineCodeComponent.init(), in: self, props: { (component, _: Bool) in
                    component.section = self.section
                }),
                disruptionBadgeComponent,
            ])
    }
}
