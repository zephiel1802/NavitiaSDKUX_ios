import Foundation
import Render
import NavitiaSDK

class JourneyRoadmapSectionDescriptionComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self).add(children: [
            ComponentNode(DescriptionComponent(), in: self, props: { (component: DescriptionComponent, hasKey: Bool) in
                component.section = self.section
            }),
            ComponentNode(DetailsComponent(), in: self, props: { (component: DetailsComponent, hasKey: Bool) in
                component.section = self.section
            })
        ])
    }

    private class DescriptionComponent: ViewComponent {
        let modes = Modes()
        var section: Section?

        override func render() -> NodeType {
            return ComponentNode(JourneyRoadmapSectionLayoutComponent(), in: self, props: { (component: JourneyRoadmapSectionLayoutComponent, hasKey: Bool) in
                component.styles = self.styles

                component.firstComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = [
                        "flexGrow": 1,
                        "alignItems": YGAlign.center,
                        "justifyContent": YGJustify.center,
                    ]
                }).add(children: [
                    ComponentNode(ModeComponent(), in: self, props: { (component: ModeComponent, hasKey: Bool) in
                        component.styles = [
                            "height": 28,
                        ]

                        component.section = self.section
                    })
                ])

                component.secondComponent = ComponentNode(LineDiagramComponent(), in: self, props: { (component: LineDiagramComponent, hasKey: Bool) in
                    component.color = self.section!.displayInformations?.color
                })

                component.thirdComponent = ComponentNode(ContentContainerComponent(), in: self).add(children: [
                    ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                        component.styles = [
                            "flexDirection": YGFlexDirection.row,
                        ]
                    }).add(children: [
                        ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                            component.styles = [
                                "fontSize": 15,
                                "marginRight": 5,
                            ]

                            component.text = self.modes.getPhysicalMode(section: self.section)
                        }),
                        ComponentNode(LineCodeComponent(), in: self, props: { (component: LineCodeComponent, hasKey: Bool) in
                            component.section = self.section
                        })
                    ]),
                    ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                        component.styles = [
                            "flexDirection": YGFlexDirection.row,
                        ]
                    }).add(children: [
                        ComponentNode(IconComponent(), in: self, props: { (component, hasKey: Bool) in
                            component.name = "direction"
                            component.styles = [
                                "fontSize": 12,
                                "marginRight": 5,
                            ]
                        }),
                        ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                            component.styles = [
                                "fontSize": 15,
                                "numberOfLines": 0,
                                "lineBreakMode": NSLineBreakMode.byWordWrapping,
                            ]

                            component.text = self.section!.displayInformations!.direction!
                        })
                    ])
                ])
            })
        }

    }

    private class DetailsComponent: ViewComponent {
        var section: Section?

        override func render() -> NodeType {
            var detailsContainer = ComponentNode(ViewComponent(), in: self)
            var allDetailsRows: [NodeType] = []

            detailsContainer.add(children: [
                ComponentNode(DetailsHeaderComponent(), in: self, props: { (component: DetailsHeaderComponent, hasKey: Bool) in
                    component.styles = self.styles

                    component.color = self.section!.displayInformations?.color
                })
            ])

            detailsContainer.add(children: self.section!.stopDateTimes!.filter { stopDateTime in
                return stopDateTime != nil
            }.map { stopDateTime -> NodeType in
                return ComponentNode(IntermediateStopPointComponent(), in: self, props: { (component: IntermediateStopPointComponent, hasKey: Bool) in
                    component.styles = self.styles

                    component.stopDateTime = stopDateTime
                    component.color = self.section!.displayInformations?.color
                })
            })

            return detailsContainer
        }
    }

    private class DetailsHeaderComponent: ViewComponent {
        var color: String?

        override func render() -> NodeType {
            return ComponentNode(JourneyRoadmapSectionLayoutComponent(), in: self, props: { (component: JourneyRoadmapSectionLayoutComponent, hasKey: Bool) in
                component.styles = self.styles

                component.firstComponent = ComponentNode(ViewComponent(), in: self)

                component.secondComponent = ComponentNode(LineDiagramComponent(), in: self, props: { (component: LineDiagramComponent, hasKey: Bool) in
                    component.color = self.color
                })

                component.thirdComponent = ComponentNode(ContentContainerComponent(), in: self).add(children: [
                    ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                        component.styles = [
                            "flexDirection": YGFlexDirection.row,
                        ]
                    }).add(children: [
                        ComponentNode(IconComponent(), in: self, props: { (component, hasKey: Bool) in
                            component.name = "arrow-details-up"
                            component.styles = [
                                "color": UIColor.lightGray,
                                "fontSize": 12,
                                "marginRight": 5,
                            ]
                        }),
                        ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                            component.styles = [
                                "color": UIColor.lightGray,
                                "fontSize": 13,
                                "marginRight": 5,
                            ]

                            component.text = NSLocalizedString("component.JourneyRoadmapSectionDescriptionComponent.detailsHeaderTitle",
                                    bundle: self.bundle,
                                    comment: "Details header title for journey roadmap section"
                            )
                        })
                    ])
                ])
            })
        }
    }

    private class IntermediateStopPointComponent: ViewComponent {
        var stopDateTime: StopDateTime?
        var color: String?

        override func render() -> NodeType {
            return ComponentNode(JourneyRoadmapSectionLayoutComponent(), in: self, props: { (component: JourneyRoadmapSectionLayoutComponent, hasKey: Bool) in
                component.styles = self.styles

                component.firstComponent = ComponentNode(ViewComponent(), in: self)

                component.secondComponent = ComponentNode(LineDiagramComponent(), in: self, props: { (component: LineDiagramComponent, hasKey: Bool) in
                    component.color = self.color
                })

                component.thirdComponent = ComponentNode(ContentContainerComponent(), in: self).add(children: [
                    ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                        component.styles = [
                            "flexDirection": YGFlexDirection.row,
                        ]
                    }).add(children: [
                        ComponentNode(IconComponent(), in: self, props: { (component, hasKey: Bool) in
                            component.name = "origin"
                            component.styles = [
                                "color": getUIColorFromHexadecimal(hex: self.color!),
                                "fontSize": 10,
                                "marginRight": 5,
                            ]
                        }),
                        ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                            component.styles = [
                                "color": UIColor.darkText,
                                "fontWeight": "bold",
                                "fontSize": 12,
                                "marginRight": 5,
                            ]

                            component.text = self.stopDateTime!.stopPoint!.label!
                        })
                    ])
                ])
            })
        }
    }

    private class LineDiagramComponent: ViewComponent {
        var color: String?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": UIColor.white,
                    "flexGrow": 1,
                    "alignItems": YGAlign.center,
                ]
            }).add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = [
                        "backgroundColor": getUIColorFromHexadecimal(hex: self.color!),
                        "flexGrow": 1,
                        "width": 5,
                    ]
                })
            ])
        }
    }

    private class ContentContainerComponent: ViewComponent {
        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": UIColor.white,
                    "paddingHorizontal": 5,
                    "paddingTop": 14,
                    "paddingBottom": 18,
                ]
            })
        }
    }
}
