import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.PublicTransport.Description {
    class ModeIconComponent: ViewComponent {
        var section: Section?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.modeContainerStyle
            }).add(children: [
                ComponentNode(ModeComponent(), in: self, props: { (component: ModeComponent, hasKey: Bool) in
                    component.styles = self.modeIconStyle
                    component.section = self.section
                })
            ])
        }

        let modeContainerStyle: [String: Any] = [
            "flexGrow": 1,
            "alignItems": YGAlign.center
        ]
        let modeIconStyle: [String: Any] = [
            "height": 28,
        ]
    }
}
