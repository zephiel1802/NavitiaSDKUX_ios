import Render
import NavitiaSDK

class LineCodeWithDisruptionStatus: ViewComponent {
    var section: Section?
    var disruptions: [Disruption]?

    override func render() -> NodeType {
        var disruptionBadgeComponent: NodeType = ComponentNode(ViewComponent(), in: self)
        if disruptions != nil && disruptions!.count > 0 {
            disruptionBadgeComponent = ComponentNode(DisruptionBadgeComponent(), in: self, props: { (component: DisruptionBadgeComponent, _: Bool) in
                component.disruptions = self.disruptions
            })
        }
        
        return ComponentNode(ViewComponent(), in: self)
            .add(children: [
                ComponentNode(LineCodeComponent(), in: self, props: { (component: LineCodeComponent, _: Bool) in
                    component.section = self.section
                }),
                disruptionBadgeComponent,
            ])
    }
}
