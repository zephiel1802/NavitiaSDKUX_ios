import Render
import NavitiaSDK

class LineCodeWithDisruptionStatus: ViewComponent {
    var section: Section?
    var disruptions: [Disruption]?

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self)
            .add(children: [
                ComponentNode(LineCodeComponent(), in: self, props: { (component: LineCodeComponent, _: Bool) in
                    component.section = self.section
                }),
                ComponentNode(DisruptionBadge(), in: self, props: { (component: DisruptionBadge, _: Bool) in
                    component.disruptions = self.disruptions
                })
            ])
    }
}
