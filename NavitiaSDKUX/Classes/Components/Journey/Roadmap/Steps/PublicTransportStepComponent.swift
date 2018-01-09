import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Steps {
    class PublicTransportStepComponent: ViewComponent {
        let JourneyRoadmap2ColumnsLayout: Components.Journey.Roadmap.Steps.JourneyRoadmap2ColumnsLayout.Type = Components.Journey.Roadmap.Steps.JourneyRoadmap2ColumnsLayout.self
        let PlainPart: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.LineDiagram.PlainPart.Type = Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.LineDiagram.PlainPart.self
        let StopPointPart: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.StopPointPart.Type = Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.StopPointPart.self
        let DetailsPart: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.DetailsPart.Type = Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.DetailsPart.self
        let ModeIconPart: Components.Journey.Roadmap.Steps.Parts.ModeIconPart.Type = Components.Journey.Roadmap.Steps.Parts.ModeIconPart.self
        let DirectionPart: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.DirectionPart.Type = Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.DirectionPart.self
        let DisruptionDescriptionPart: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.DisruptionDescriptionPart.Type = Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.DisruptionDescriptionPart.self
        let WaitingPart: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.WaitingPart.Type = Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.WaitingPart.self
        
        var section: Section?
        var disruptions: [Disruption]?
        var waitingTime: Int32?

        override func render() -> NodeType {
            return ComponentNode(CardComponent(), in: self, props:{ (component: CardComponent, _) in
                component.styles = self.containerStyles
            }).add(children: [
                ComponentNode(self.JourneyRoadmap2ColumnsLayout.init(), in: self, props: { (component: Components.Journey.Roadmap.Steps.JourneyRoadmap2ColumnsLayout, _) in
                    component.leftChildren = [
                        ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, _) in
                            component.styles = self.modeIconContainerStyles
                        }).add(children: [
                            ComponentNode(self.ModeIconPart.init(), in: self, props: { (component: Components.Journey.Roadmap.Steps.Parts.ModeIconPart, _) in
                                component.section = self.section
                            })
                        ])
                    ]
                    component.rightChildren = [
                        ComponentNode(ViewComponent(), in: self).add(children: [
                            ComponentNode(self.DirectionPart.init(), in: self, props: { (component: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.DirectionPart, _) in
                                component.section = self.section
                                component.disruptions = self.disruptions
                            })
                        ])
                    ]
                    if self.disruptions != nil && self.disruptions!.count > 0 {
                        component.rightChildren!.append(
                            ComponentNode(self.DisruptionDescriptionPart.init(), in: self, props: { (component: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.DisruptionDescriptionPart, _) in
                                component.section = self.section
                                component.disruptions = self.disruptions
                            })
                        )
                    }
                    if self.waitingTime != nil {
                        component.rightChildren!.append(
                            ComponentNode(self.WaitingPart.init(), in: self, props: { (component: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.WaitingPart, _) in
                                component.waitingTime = self.waitingTime!
                            })
                        )
                    }
                }),
                ComponentNode(ViewComponent(), in: self, props:{ (component: ViewComponent, _) in
                    component.styles = self.diagramContainerStyles
                }).add(children: [
                    ComponentNode(PlainPart.init(), in: self, props: { (component: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.LineDiagram.PlainPart, _) in
                        component.color = getUIColorFromHexadecimal(hex: (self.section?.displayInformations?.color)!)
                    }),
                    ComponentNode(ViewComponent(), in: self).add(children: [
                        ComponentNode(self.StopPointPart.init(), in: self, props: { (component: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.StopPointPart, _) in
                            component.section = self.section
                            component.sectionWay = SectionWay.departure
                        }),
                        ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, _) in
                            component.styles = self.bodyContainerStyles
                        }).add(children: [
                            ComponentNode(self.DetailsPart.init(), in: self, key: "\(String(describing: type(of: self)))_\(self.section!.type!)_\(self.section!.departureDateTime!)", props: { (component: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.DetailsPart, _) in
                                component.section = self.section
                            })
                        ]),
                        ComponentNode(self.StopPointPart.init(), in: self, props: { (component: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.StopPointPart, _) in
                            component.section = self.section
                            component.sectionWay = SectionWay.arrival
                        })
                    ]),
                ])
            ])
        }
        
        let diagramContainerStyles: [String: Any] = [
            "marginTop" : 20,
        ]

        let containerStyles: [String: Any] = [    
            "paddingVertical": config.metrics.margin,
        ]
        
        let modeIconContainerStyles: [String: Any] = [
            "paddingTop": 10,
        ]
        
        let bodyContainerStyles: [String: Any] = [
            "paddingVertical": config.metrics.margin,
        ]
    }
}
