import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.PublicTransport {
    struct ComponentVisibilityState: StateType {
        var visible: Bool = true
    }

    class DetailsComponent: StylizedComponent<ComponentVisibilityState> {
        let DetailedButtonComponent = Components.Journey.Roadmap.Sections.DetailedButtonComponent.self
        let IntermediateStopPointComponent = Components.Journey.Roadmap.Sections.PublicTransport.Details.IntermediateStopPointComponent.self
        let SectionRowLayoutComponent = Components.Journey.Roadmap.Sections.SectionRowLayoutComponent.self
        
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
                        }
                    }).add(children: [
                        ComponentNode(self.SectionRowLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionRowLayoutComponent, _) in
                            component.thirdComponent = ComponentNode(self.DetailedButtonComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.DetailedButtonComponent, _) in
                                component.styles = self.styles
                                component.color = getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(self.section!.displayInformations?.color))
                                component.collapsed = !self.state.visible
                            })
                        }),
                    ])
                ])
                detailsContainer.add(children: self.section!.stopDateTimes![1...(self.section!.stopDateTimes!.count - 2)].filter { stopDateTime in
                    return stopDateTime != nil
                }.map { stopDateTime -> NodeType in
                    return ComponentNode(IntermediateStopPointComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Details.IntermediateStopPointComponent, hasKey: Bool) in
                        component.styles = self.styles
                        component.stopDateTime = stopDateTime
                        component.color = getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(self.section!.displayInformations?.color))
                    })
                })
            }

            return detailsContainer
        }
    }
}
