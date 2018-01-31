import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts {
    struct ComponentVisibilityState: StateType {
        var visible: Bool = false
    }

    class DetailsPart: StylizedComponent<ComponentVisibilityState> {
        let DetailButtonPart: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.Details.DetailButtonPart.Type = Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.Details.DetailButtonPart.self
        let IntermediateStopPointPart: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.Details.IntermediateStopPointPart.Type = Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.Details.IntermediateStopPointPart.self
        let JourneyRoadmap3ColumnsLayout: Components.Journey.Roadmap.Steps.JourneyRoadmap3ColumnsLayout.Type = Components.Journey.Roadmap.Steps.JourneyRoadmap3ColumnsLayout.self
        
        var section: Section?

        override func render() -> NodeType {
            let detailsContainer = ComponentNode(ViewComponent(), in: self)

            if (self.section!.stopDateTimes != nil && self.section!.stopDateTimes!.count > 2) {
                detailsContainer.add(children: [
                    ComponentNode(ActionComponent(), in: self, props: { (component, _) in
                        component.onTap = { [weak self] _ in
                            self?.setState { state in
                                state.visible = !state.visible
                            }
                            self?.update()
                        }
                    }).add(children: [
                        ComponentNode(self.JourneyRoadmap3ColumnsLayout.init(), in: self, props: { (component, _) in
                            component.rightChildren =  [
                                ComponentNode(self.DetailButtonPart.init(), in: self, props: { (component, _) in
                                    component.color = getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(self.section!.displayInformations?.color))
                                    component.collapsed = !self.state.visible
                                    component.text = "\(self.section!.stopDateTimes!.count - 1) \(NSLocalizedString("stops",bundle: self.bundle,comment: "Details header title for journey roadmap section"))"
                                })
                            ]
                        }),
                    ])
                ])

                if (self.state.visible) {
                    let intermediateStopPointContainer = ComponentNode(ViewComponent(), in: self, props: {(component, _) in
                        component.styles = self.intermediateStopsStyles
                    }).add(children: self.section!.stopDateTimes![1...(self.section!.stopDateTimes!.count - 2)].map { stopDateTime -> NodeType in
                        return ComponentNode(self.IntermediateStopPointPart.init(), in: self, props: { (component, _) in
                            component.stopDateTime = stopDateTime
                            component.color = getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(self.section!.displayInformations?.color))
                        })
                    })

                    detailsContainer.add(children: [intermediateStopPointContainer])
                }
            }

            return detailsContainer
        }
        
        let intermediateStopsStyles: [String: Any] = [
            "marginTop": config.metrics.marginL
        ]
    }
}
