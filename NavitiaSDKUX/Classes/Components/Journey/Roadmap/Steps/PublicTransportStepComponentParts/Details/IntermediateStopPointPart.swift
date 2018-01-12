import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.Details {
    class IntermediateStopPointPart: ViewComponent {
        let Roadmap3ColumnsLayout: Components.Journey.Roadmap.Steps.JourneyRoadmap3ColumnsLayout.Type = Components.Journey.Roadmap.Steps.JourneyRoadmap3ColumnsLayout.self
        let StopPointIconPart: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.LineDiagram.StopPointIconPart.Type = Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.LineDiagram.StopPointIconPart.self
        
        var stopDateTime: StopDateTime?
        var color: UIColor?

        override func render() -> NodeType {
            return ComponentNode(self.Roadmap3ColumnsLayout.init(), in: self, props: { (component, _) in
                component.styles = self.containerStyles

                component.middleChildren = [
                    ComponentNode(self.StopPointIconPart.init(), in: self, props: { (component, _) in
                        component.color = self.color!
                        component.outerFontSize = 12
                        component.innerFontSize = 0
                    })
                ]
                
                component.rightChildren = [
                    ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                        component.styles = self.stopPointContainerStyles
                    }).add(children: [
                        ComponentNode(LabelComponent(), in: self, props: { (component, _) in
                            component.styles = self.stopPointLabelStyles
                            component.text = self.stopDateTime!.stopPoint!.label!
                        })
                    ])
                ]
            })
        }

        let containerStyles: [String: Any] = [
            "paddingBottom": config.metrics.margin,
        ]
        let stopPointContainerStyles: [String: Any] = [
            "paddingHorizontal": config.metrics.marginS,
        ]
        let stopPointLabelStyles: [String: Any] = [
            "fontSize": config.metrics.textS,
            "fontWeight": "bold",
            "color": UIColor.darkText,
        ]
    }
}
