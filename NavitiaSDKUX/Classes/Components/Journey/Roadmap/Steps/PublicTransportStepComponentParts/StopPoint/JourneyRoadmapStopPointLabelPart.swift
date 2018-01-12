import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.StopPoint {
    class StopPointLabelPart: ViewComponent {
        var stopPointLabel: String?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                component.styles = self.stopPointContainerStyle
            }).add(children: [
                ComponentNode(LabelComponent(), in: self, props: { (component, _) in
                    component.styles = self.stopPointLabelStyle
                    component.text = self.stopPointLabel!
                })
            ])
        }

        let stopPointContainerStyle: [String: Any] = [
            "paddingHorizontal": config.metrics.marginS,
        ]
        let stopPointLabelStyle: [String: Any] = [
            "color": config.colors.darkText,
            "fontWeight": "bold",
            "fontSize": config.metrics.text,
        ]
    }
}
