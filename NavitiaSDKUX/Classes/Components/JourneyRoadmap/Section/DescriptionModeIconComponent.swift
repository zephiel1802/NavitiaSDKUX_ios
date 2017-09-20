import Foundation
import Render
import NavitiaSDK

class DescriptionModeIconComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
            component.styles = [
                "flexGrow": 1,
                "alignItems": YGAlign.center,
                "justifyContent": YGJustify.center,
            ]
        }).add(children: [
            ComponentNode(ModeComponent(), in: self, props: { (component: ModeComponent, hasKey: Bool) in
                component.styles = [
                    "height": 28,
                ]

                component.section = self.section
            })
        ])
    }
}
