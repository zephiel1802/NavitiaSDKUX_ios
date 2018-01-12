import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Steps {
    class SharedStepComponent: ViewComponent {
        let JourneyRoadmap2ColumnsLayout: Components.Journey.Roadmap.Steps.JourneyRoadmap2ColumnsLayout.Type = Components.Journey.Roadmap.Steps.JourneyRoadmap2ColumnsLayout.self
        let ModeIconPart: Components.Journey.Roadmap.Steps.Parts.ModeIconPart.Type = Components.Journey.Roadmap.Steps.Parts.ModeIconPart.self
        
        var section: Section?
        var descriptionProp: NSMutableAttributedString?
        
        override func render() -> NodeType {
            return ComponentNode(CardComponent(), in: self).add(children: [
                ComponentNode(JourneyRoadmap2ColumnsLayout.init(), in: self, props: {(component, _) in
                    component.styles = self.containerStyles
                    component.leftChildren = [
                        ComponentNode(self.ModeIconPart.init(), in: self, props: {(component, _) in
                            component.section = self.section!
                        })
                    ]
                    component.rightChildren = [
                        ComponentNode(LabelComponent(), in: self, props: {(component, _) in
                            component.attributedText = self.descriptionProp!
                            component.styles = self.instructionTextStyles
                        })
                    ]
                })
            ])
        }
        
        let containerStyles: [String: Any] = [
            "paddingVertical": config.metrics.margin,
        ]
        let instructionTextStyles: [String: Any] = [
            "color": config.colors.darkText,
            "fontSize": config.metrics.text,
            "lineHeight": 6,
            "numberOfLines": 0,
        ]
    }
}

