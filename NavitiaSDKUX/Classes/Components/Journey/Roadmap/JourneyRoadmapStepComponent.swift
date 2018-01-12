import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap {
    class StepComponent: ViewComponent {
        let PublicTransportStepComponent: Components.Journey.Roadmap.Steps.PublicTransportStepComponent.Type = Components.Journey.Roadmap.Steps.PublicTransportStepComponent.self
        let SharedStepComponent: Components.Journey.Roadmap.Steps.SharedStepComponent.Type = Components.Journey.Roadmap.Steps.SharedStepComponent.self
        let SimpleStepComponent: Components.Journey.Roadmap.Steps.SimpleStepComponent.Type = Components.Journey.Roadmap.Steps.SimpleStepComponent.self
        
        var section: Section?
        var disruptions: [Disruption] = []
        var descriptionProp: NSMutableAttributedString?
        var waitingTime: Int32?
        var isBSS: Bool = false
        
        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                component.styles = self.containerStyles
            }).add(children: [
                getTypedSectionComponent(section: section!, disruptions: disruptions, description: description, waitingTime: waitingTime, isBSS: isBSS)
            ])
        }
        
        func getTypedSectionComponent(section: Section, disruptions: [Disruption], description: String?, waitingTime: Int32?, isBSS: Bool) -> NodeType {
            switch section.type! {
                case "public_transport":
                    return ComponentNode(PublicTransportStepComponent.init(), in: self, key: "\(String(describing: type(of: self)))_\(self.section!.type!)_\(self.section!.departureDateTime!)", props: { (component, _) in
                        component.section = section
                        component.disruptions = disruptions
                        if waitingTime != nil {
                            component.waitingTime = waitingTime!
                        }
                    })
                case "street_network":
                    if (isBSS) {
                        return ComponentNode(SharedStepComponent.init(), in: self, props: { (component, _) in
                            component.section = section
                            component.descriptionProp = self.descriptionProp
                        })
                    } else {
                        return ComponentNode(SimpleStepComponent.init(), in: self, props: { (component, _) in
                            component.section = section
                            component.descriptionProp = self.descriptionProp
                        })
                    }
                // case "transfer":
                default:
                    return ComponentNode(SimpleStepComponent.init(), in: self, props: { (component, _) in
                        component.section = section
                        component.descriptionProp = self.descriptionProp
                    })
            }
        }
        
        let containerStyles: [String: Any] = [
            "paddingVertical": config.metrics.margin,
        ]
    }
}
