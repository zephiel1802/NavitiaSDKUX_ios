import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Steps {
    class SimpleStepComponent: ViewComponent {
        let JourneyRoadmap2ColumnsLayout: Components.Journey.Roadmap.Steps.JourneyRoadmap2ColumnsLayout.Type = Components.Journey.Roadmap.Steps.JourneyRoadmap2ColumnsLayout.self
        
        var section: Section?
        var descriptionProp: NSMutableAttributedString?
        
        override func render() -> NodeType {
            return ComponentNode(JourneyRoadmap2ColumnsLayout.init(), in: self, props: {(component, _) in
                component.leftChildren = [
                    ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                        component.styles = self.modeContainerStyles
                    }).add(children: [
                        ComponentNode(ModeComponent(), in: self, props: {(component, _) in
                            component.section = self.section!
                        })
                        ])
                ]
                component.rightChildren = [
                    ComponentNode(LabelComponent(), in: self, props: {(component, _) in
                        component.attributedText = self.descriptionProp!
                        component.styles = self.instructionTextStyles
                    })
                ]
            })
        }
        
        let modeContainerStyles: [String: Any] = [
            "alignItems": YGAlign.center,
            "justifyContent": YGJustify.center,
            "flexGrow": 1,
        ]
        let instructionTextStyles: [String: Any] = [
            "color": config.colors.darkText,
            "fontSize": config.metrics.text,
            "lineHeight": 6,
            "numberOfLines": 0,
        ]
    }
}


