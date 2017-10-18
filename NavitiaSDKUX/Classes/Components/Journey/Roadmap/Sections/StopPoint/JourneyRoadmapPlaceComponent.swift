import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.StopPoint {
    class PlaceComponent: ViewComponent {
        var stopPointLabel: String?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.stopPointContainerStyle
            }).add(children: [
                ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                    component.styles = self.stopPointLabelStyle

                    component.text = self.stopPointLabel!
                })
            ])
        }

        let stopPointContainerStyle: [String: Any] = [
            "backgroundColor": config.colors.lighterGray,
            "paddingHorizontal": 5,
            "paddingVertical": 14,
        ]
        let stopPointLabelStyle: [String: Any] = [
            "color": config.colors.darkText,
            "fontWeight": "bold",
            "fontSize": 15,
            "numberOfLines": 2,
            "lineBreakMode": NSLineBreakMode.byWordWrapping,
        ]
    }
}
