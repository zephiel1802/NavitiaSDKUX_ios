import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections {
    class PublicTransportComponent: ViewComponent {
        let HeaderComponent:Components.Journey.Roadmap.Sections.PublicTransport.JourneyRoadmapTwoColumnsLayoutComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.JourneyRoadmapTwoColumnsLayoutComponent.self
        let SectionLayoutComponent:Components.Journey.Roadmap.Sections.SectionLayoutComponent.Type = Components.Journey.Roadmap.Sections.SectionLayoutComponent.self
        let PlainComponent:Components.Journey.Roadmap.Sections.LineDiagram.PlainComponent.Type = Components.Journey.Roadmap.Sections.LineDiagram.PlainComponent.self
        let StopPointComponent:Components.Journey.Roadmap.Sections.StopPointComponent.Type = Components.Journey.Roadmap.Sections.StopPointComponent.self
        let DetailsComponent:Components.Journey.Roadmap.Sections.PublicTransport.DetailsComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.DetailsComponent.self
        let ModeIconComponent:Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent.self
        let DirectionComponent:Components.Journey.Roadmap.Sections.PublicTransport.Description.DirectionComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.Description.DirectionComponent.self
        let DisruptionDescriptionComponent:Components.Journey.Roadmap.Sections.PublicTransport.Description.DisruptionDescriptionComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.Description.DisruptionDescriptionComponent.self
        
        var section: Section?
        var disruptions: [Disruption]?
        var waitingSection: Section?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props:{(component: ViewComponent, hasKey: Bool) in
                component.styles = self.containerStyles
            }).add(children: [
                ComponentNode(self.HeaderComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.JourneyRoadmapTwoColumnsLayoutComponent, hasKey: Bool) in
                    component.firstComponent = ComponentNode(self.ModeIconComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent, hasKey: Bool) in
                        component.styles = self.transportModeStyles
                        component.section = self.section
                    })
                    component.secondComponent = ComponentNode(ViewComponent(), in: self).add(children: [
                        ComponentNode(self.DirectionComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Description.DirectionComponent, hasKey: Bool) in
                            component.section = self.section
                            component.disruptions = self.disruptions
                        }),
                        ComponentNode(self.DisruptionDescriptionComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Description.DisruptionDescriptionComponent, hasKey: Bool) in
                            component.section = self.section
                            component.disruptions = self.disruptions
                        })
                    ])
                    if self.waitingSection != nil {
                        component.secondComponent?.add(children: [
                            ComponentNode(WaitingComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.WaitingComponent, _) in
                                component.section = self.waitingSection
                            })
                        ])
                    }
                }),
                ComponentNode(ViewComponent(), in: self, props:{(component: ViewComponent, hasKey: Bool) in
                    component.styles = self.stationListStyles
                }).add(children: [
                    ComponentNode(PlainComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.LineDiagram.PlainComponent, hasKey: Bool) in
                        component.color = getUIColorFromHexadecimal(hex: (self.section?.displayInformations?.color)!)
                    }),
                    ComponentNode(SectionLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionLayoutComponent, hasKey: Bool) in
                        component.header = ComponentNode(self.StopPointComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.StopPointComponent, hasKey: Bool) in
                            component.section = self.section
                            component.sectionWay = SectionWay.departure
                        })
                        component.body = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                            component.styles = self.containerStyles
                        }).add(children: [
                            ComponentNode(self.DetailsComponent.init(),
                                          in: self,
                                          key: "\(String(describing: type(of: self)))_\(self.section!.type!)_\(self.section!.departureDateTime!)",
                                props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.DetailsComponent, hasKey: Bool) in
                                    component.section = self.section
                            }),
                            ])
                        component.footer = ComponentNode(self.StopPointComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.StopPointComponent, hasKey: Bool) in
                            component.section = self.section
                            component.sectionWay = SectionWay.arrival
                        })
                    }),
                ])
            ])
        }

        let containerStyles: [String: Any] = [
            "paddingVertical": 12
        ]
        
        let transportModeStyles: [String: Any] = [
            "justifyContent": YGJustify.flexStart,
            "paddingTop": 10
        ]
        
        let stationListStyles: [String: Any] = [
            "marginTop" : 30
        ]
    }
}
