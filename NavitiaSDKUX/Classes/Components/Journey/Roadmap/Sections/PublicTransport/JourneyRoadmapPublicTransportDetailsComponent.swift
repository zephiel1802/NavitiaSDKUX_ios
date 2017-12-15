import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.PublicTransport {
    struct ComponentVisibilityState: StateType {
        var visible: Bool = false
    }

    class DetailsComponent: StylizedComponent<ComponentVisibilityState> {
        let DetailButtonComponent:Components.Journey.Roadmap.Sections.DetailButtonComponent.Type = Components.Journey.Roadmap.Sections.DetailButtonComponent.self
        let IntermediateStopPointComponent:Components.Journey.Roadmap.Sections.PublicTransport.Details.IntermediateStopPointComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.Details.IntermediateStopPointComponent.self
        let SectionRowLayoutComponent:Components.Journey.Roadmap.Sections.SectionRowLayoutComponent.Type = Components.Journey.Roadmap.Sections.SectionRowLayoutComponent.self
        
        var section: Section?

        override func render() -> NodeType {
            let detailsContainer = ComponentNode(ViewComponent(), in: self)

            if (self.section!.stopDateTimes != nil && self.section!.stopDateTimes!.count > 2) {
                detailsContainer.add(children: [
                    ComponentNode(ActionComponent(), in: self, props: { (component: ActionComponent, hasKey: Bool) in
                        component.onTap = { [weak self] _ in
                            self?.setState { state in
                                state.visible = !state.visible
                            }
                            self?.update()
                        }
                    }).add(children: [
                        ComponentNode(self.SectionRowLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionRowLayoutComponent, _) in
                            component.styles = self.containerStyles
                            component.thirdComponent = ComponentNode(self.DetailButtonComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.DetailButtonComponent, _) in
                                component.color = getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(self.section!.displayInformations?.color))
                                component.collapsed = !self.state.visible
                                component.text = """
                                \(self.section!.stopDateTimes!.count - 1) \(NSLocalizedString("component.JourneyRoadmapSectionPublicTransportDescriptionComponent.stopsHeaderTitle",
                                bundle: self.bundle,
                                comment: "Details header title for journey roadmap section"
                                ))
                                """
                            })
                        }),
                    ])
                ])
                if (self.state.visible) {
                    detailsContainer.add(children: self.section!.stopDateTimes![1...(self.section!.stopDateTimes!.count - 2)].map { stopDateTime -> NodeType in
                        return ComponentNode(self.IntermediateStopPointComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Details.IntermediateStopPointComponent, hasKey: Bool) in
                            component.styles = self.styles
                            component.stopDateTime = stopDateTime
                            component.color = getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(self.section!.displayInformations?.color))
                        })
                    })
                }
            }

            return detailsContainer
        }
        
        let containerStyles: [String: Any] = [
            "paddingBottom": 8,
        ]
    }
}
