import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Steps {
    class SimpleStepComponent: ViewComponent {
        let JourneyRoadmap2ColumnsLayout: Components.Journey.Roadmap.Steps.JourneyRoadmap2ColumnsLayout.Type = Components.Journey.Roadmap.Steps.JourneyRoadmap2ColumnsLayout.self
        
        var section: Section?
        var descriptionProp: NSMutableAttributedString?
        
        override func render() -> NodeType {
            return ComponentNode(JourneyRoadmap2ColumnsLayout.init(), in: self, props: {(component: Components.Journey.Roadmap.Steps.JourneyRoadmap2ColumnsLayout, _) in
                component.leftChildren = [
                    ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, _) in
                        component.styles = self.modeContainerStyles
                    }).add(children: [
                        ComponentNode(ModeComponent(), in: self, props: {(component: ModeComponent, _) in
                            component.section = self.section!
                        })
                        ])
                ]
                component.rightChildren = [
                    ComponentNode(LabelComponent(), in: self, props: {(component: LabelComponent, _) in
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


