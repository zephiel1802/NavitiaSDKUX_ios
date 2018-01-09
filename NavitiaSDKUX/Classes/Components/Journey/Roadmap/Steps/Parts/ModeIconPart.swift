import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Steps.Parts {
    class ModeIconPart: ViewComponent {
        var section: Section?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, _) in
                component.styles = self.containerStyle
            }).add(children: [
                ComponentNode(ModeComponent(), in: self, props: { (component: ModeComponent, _) in
                    component.section = self.section
                })
            ])
        }

        let containerStyle: [String: Any] = [
            "marginTop": 14,
            "alignItems": YGAlign.center,
        ]
    }
}
