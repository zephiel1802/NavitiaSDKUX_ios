import Foundation
import Render
import NavitiaSDK

class TimeComponent: ViewComponent {
    var dateTime: String?

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
            component.styles = self.timeContainerStyle
        }).add(children: [
            ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.paddingCenteringStyle
            }),
            ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                component.styles = self.timeLabelStyle

                component.text = timeText(isoString: self.dateTime!)
            }),
            ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.paddingCenteringStyle
            })
        ])
    }

    let timeContainerStyle: [String: Any] = [
        "flexGrow": 1,
        "alignItems": YGAlign.center,
        "justifyContent": YGJustify.center,
    ]
    let paddingCenteringStyle: [String: Any] = [
        "flexGrow": 1,
    ]
    let timeLabelStyle: [String: Any] = [
        "color": config.colors.darkText,
        "fontSize": 12,
        "numberOfLines": 1,
        "lineBreakMode": NSLineBreakMode.byClipping,
    ]
}
