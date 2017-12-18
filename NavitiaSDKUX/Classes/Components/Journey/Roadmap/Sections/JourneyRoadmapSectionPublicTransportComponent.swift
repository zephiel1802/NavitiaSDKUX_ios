import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections {
    class PublicTransportComponent: ViewComponent {
        let JourneyRoadmap2ColumnsLayout:Components.Journey.Roadmap.Sections.PublicTransport.JourneyRoadmap2ColumnsLayout.Type = Components.Journey.Roadmap.Sections.PublicTransport.JourneyRoadmap2ColumnsLayout.self
        let SectionLayoutComponent:Components.Journey.Roadmap.Sections.SectionLayoutComponent.Type = Components.Journey.Roadmap.Sections.SectionLayoutComponent.self
        let PlainComponent:Components.Journey.Roadmap.Sections.LineDiagram.PlainComponent.Type = Components.Journey.Roadmap.Sections.LineDiagram.PlainComponent.self
        let StopPointComponent:Components.Journey.Roadmap.Sections.StopPointComponent.Type = Components.Journey.Roadmap.Sections.StopPointComponent.self
        let DetailsComponent:Components.Journey.Roadmap.Sections.PublicTransport.DetailsComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.DetailsComponent.self
        let ModeIconComponent:Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent.self
        let DirectionComponent:Components.Journey.Roadmap.Sections.PublicTransport.Description.DirectionComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.Description.DirectionComponent.self
        let DisruptionDescriptionComponent:Components.Journey.Roadmap.Sections.PublicTransport.Description.DisruptionDescriptionComponent.Type = Components.Journey.Roadmap.Sections.PublicTransport.Description.DisruptionDescriptionComponent.self
        
        var section: Section?
        var disruptions: [Disruption]?
        var waitingTime: Int32?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props:{(component: ViewComponent, hasKey: Bool) in
                component.styles = self.containerStyles
            }).add(children: [
                ComponentNode(self.JourneyRoadmap2ColumnsLayout.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.JourneyRoadmap2ColumnsLayout, hasKey: Bool) in
                    component.leftChildren = ComponentNode(ViewComponent(), in: self, props: {(component: ViewComponent, _) in
                        component.styles = self.modeIconContainerStyles
                    }).add(children: [
                        ComponentNode(self.ModeIconComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Description.ModeIconComponent, hasKey: Bool) in
                            component.section = self.section
                        })
                    ])
                    component.rightChildren = ComponentNode(ViewComponent(), in: self).add(children: [
                        ComponentNode(self.DirectionComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Description.DirectionComponent, hasKey: Bool) in
                            component.section = self.section
                            component.disruptions = self.disruptions
                        })
                    ])
                    if self.disruptions != nil && self.disruptions!.count > 0 {
                        component.rightChildren?.add(children: [
                            ComponentNode(self.DisruptionDescriptionComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.Description.DisruptionDescriptionComponent, hasKey: Bool) in
                                component.section = self.section
                                component.disruptions = self.disruptions
                            })
                        ])
                    }
                    if self.waitingTime != nil {
                        component.rightChildren?.add(children: [
                            ComponentNode(WaitingComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.WaitingComponent, _) in
                                component.waitingTime = self.waitingTime!
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
                            ComponentNode(self.DetailsComponent.init(), in: self, key: "\(String(describing: type(of: self)))_\(self.section!.type!)_\(self.section!.departureDateTime!)", props: { (component: Components.Journey.Roadmap.Sections.PublicTransport.DetailsComponent, hasKey: Bool) in
                                component.section = self.section
                            })
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
        
        let modeIconContainerStyles: [String: Any] = [
            "paddingTop": 10
        ]
        
        let stationListStyles: [String: Any] = [
            "marginTop" : 30
        ]
    }
}
