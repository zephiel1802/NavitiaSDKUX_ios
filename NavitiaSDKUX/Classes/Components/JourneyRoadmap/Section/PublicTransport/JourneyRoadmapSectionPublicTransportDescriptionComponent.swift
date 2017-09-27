import Foundation
import Render
import NavitiaSDK

struct ComponentVisibilityState: StateType {
    var visible: Bool = true
}

class JourneyRoadmapSectionPublicTransportDescriptionComponent: ViewComponent {
    var section: Section?

    override func render() -> NodeType {
        // NSLog("JourneyRoadmapSectionDescriptionComponent")
        return ComponentNode(ViewComponent(), in: self).add(children: [
            ComponentNode(DescriptionComponent(), in: self, props: { (component: DescriptionComponent, hasKey: Bool) in
                component.section = self.section
            }),
            ComponentNode(DetailsComponent(), in: self, key: "sectionDetails\(self.section!.type!)_\(self.section!.departureDateTime!)", props: { (component: DetailsComponent, hasKey: Bool) in
                component.section = self.section
            })
        ])
    }

    // DESCRIPTION
    private class DescriptionComponent: ViewComponent {
        var section: Section?

        override func render() -> NodeType {
            return ComponentNode(JourneyRoadmapSectionLayoutComponent(), in: self, props: { (component: JourneyRoadmapSectionLayoutComponent, hasKey: Bool) in
                component.styles = self.styles

                component.firstComponent = ComponentNode(DescriptionModeIconComponent(), in: self, props: { (component: DescriptionModeIconComponent, hasKey: Bool) in
                    component.section = self.section
                })

                component.secondComponent = ComponentNode(LineDiagramComponent(), in: self, props: { (component: LineDiagramComponent, hasKey: Bool) in
                    component.color = getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(self.section!.displayInformations?.color))
                })

                component.thirdComponent = ComponentNode(DescriptionContentComponent(), in: self, props: { (component: DescriptionContentComponent, hasKey: Bool) in
                    component.section = self.section
                })
            })
        }
    }

    private class DescriptionContentComponent: ViewComponent {
        var section: Section?
        let modes = Modes()

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.descriptionContainerStyle
            }).add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.modeContainerStyle
                }).add(children: [
                    ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                        component.styles = self.physicalModeLabelStyle
                        component.text = self.modes.getPhysicalMode(section: self.section)
                    }),
                    ComponentNode(LineCodeComponent(), in: self, props: { (component: LineCodeComponent, hasKey: Bool) in
                        component.section = self.section
                    })
                ]),
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.directionContainerStyle
                }).add(children: [
                    ComponentNode(IconComponent(), in: self, props: { (component, hasKey: Bool) in
                        component.name = "direction"
                        component.styles = self.directionIconStyle
                    }),
                    ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                        component.styles = self.directionLabelStyle
                        component.text = self.section!.displayInformations!.direction!
                    })
                ])
            ])
        }

        let descriptionContainerStyle: [String: Any] = [
            "backgroundColor": UIColor.white,
            "paddingHorizontal": 5,
            "paddingTop": 14,
            "paddingBottom": 18,
        ]
        let modeContainerStyle: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
        ]
        let physicalModeLabelStyle: [String: Any] = [
            "fontSize": 15,
            "marginRight": 5,
        ]
        let directionContainerStyle: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
        ]
        let directionIconStyle: [String: Any] = [
            "fontSize": 12,
            "marginRight": 5,
        ]
        let directionLabelStyle: [String: Any] = [
            "fontSize": 15,
            "numberOfLines": 0,
            "lineBreakMode": NSLineBreakMode.byWordWrapping,
            "flexShrink": 1,
        ]
    }

    // DETAILS
    private class DetailsComponent: StylizedComponent<ComponentVisibilityState> {
        var section: Section?

        override func render() -> NodeType {
            var detailsContainer = ComponentNode(ViewComponent(), in: self)

            if (self.section!.stopDateTimes != nil && self.section!.stopDateTimes!.count > 2) {
                // NSLog("###### self.state.visible " + self.state.visible.description)
                detailsContainer.add(children: [
                    ComponentNode(ActionComponent(), in: self, props: { (component: ActionComponent, hasKey: Bool) in
                        component.onTap = { [weak self] _ in
                            self?.setState { state in
                                // NSLog("BEFORE state.visible " + state.visible.description)
                                state.visible = !state.visible
                                // NSLog("AFTER state.visible " + state.visible.description)
                            }
                        }
                    }).add(children: [
                        ComponentNode(DetailsHeaderComponent(), in: self, props: { (component: DetailsHeaderComponent, hasKey: Bool) in
                            component.styles = self.styles
                            component.color = getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(self.section!.displayInformations?.color))
                            component.collapsed = !self.state.visible
                            // NSLog(">>>>>> component.collapsed " + component.collapsed.description)
                        })
                    ])
                ])

                detailsContainer.add(children: self.section!.stopDateTimes![1...(self.section!.stopDateTimes!.count - 2)].filter { stopDateTime in
                    return stopDateTime != nil
                }.map { stopDateTime -> NodeType in
                    return ComponentNode(IntermediateStopPointComponent(), in: self, props: { (component: IntermediateStopPointComponent, hasKey: Bool) in
                        component.styles = self.styles
                        component.stopDateTime = stopDateTime
                        component.color = getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(self.section!.displayInformations?.color))
                    })
                })

                detailsContainer.add(children: [
                    ComponentNode(DetailsFooterComponent(), in: self, props: { (component: DetailsFooterComponent, hasKey: Bool) in
                        component.styles = self.styles
                        component.color = getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(self.section!.displayInformations?.color))
                    })
                ])
            }

            return detailsContainer
        }
    }

    private class DetailsHeaderComponent: ViewComponent {
        var color: UIColor?
        var collapsed: Bool = true

        override func render() -> NodeType {
            // NSLog(">>>>>> DetailsHeaderComponent.collapsed " + self.collapsed.description)

            return ComponentNode(JourneyRoadmapSectionLayoutComponent(), in: self, props: { (component: JourneyRoadmapSectionLayoutComponent, hasKey: Bool) in
                component.styles = self.styles

                component.firstComponent = ComponentNode(ViewComponent(), in: self)

                component.secondComponent = ComponentNode(LineDiagramComponent(), in: self, props: { (component: LineDiagramComponent, hasKey: Bool) in
                    component.color = self.color
                })

                component.thirdComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.detailsHeaderContainerStyle
                }).add(children: [
                    ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, hasKey: Bool) in
                        component.styles = self.collapserWayIconStyle
                        component.name = self.collapsed ? "arrow-details-down" : "arrow-details-up"
                        // NSLog(">>>>>> IconComponent.name " + component.name)
                    }),
                    ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                        component.styles = self.detailsHeaderTitleStyle
                        component.text = NSLocalizedString("component.JourneyRoadmapSectionPublicTransportDescriptionComponent.detailsHeaderTitle",
                                bundle: self.bundle,
                                comment: "Details header title for journey roadmap section"
                        )
                    })
                ])

            })
        }

        let detailsHeaderContainerStyle: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
            "backgroundColor": UIColor.white,
            "paddingHorizontal": 5,
            "paddingTop": 0,
            "paddingBottom": 5,
        ]
        let collapserWayIconStyle: [String: Any] = [
            "color": UIColor.lightGray,
            "fontSize": 12,
            "marginRight": 5,
        ]
        let detailsHeaderTitleStyle: [String: Any] = [
            "color": UIColor.lightGray,
            "fontSize": 13,
            "marginRight": 5,
        ]
    }

    private class IntermediateStopPointComponent: ViewComponent {
        var stopDateTime: StopDateTime?
        var color: UIColor?

        override func render() -> NodeType {
            return ComponentNode(JourneyRoadmapSectionLayoutComponent(), in: self, props: { (component: JourneyRoadmapSectionLayoutComponent, hasKey: Bool) in
                component.styles = self.styles

                component.firstComponent = ComponentNode(ViewComponent(), in: self)

                component.secondComponent = ComponentNode(LineDiagramForIntermediateStopPointComponent(), in: self, props: { (component: LineDiagramForIntermediateStopPointComponent, hasKey: Bool) in
                    component.color = self.color
                })

                component.thirdComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.intermediateStopPointLabelContainerStyle
                }).add(children: [
                    ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                        component.styles = self.intermediateStopPointLabelStyle

                        component.text = self.stopDateTime!.stopPoint!.label!
                    })
                ])
            })
        }

        let intermediateStopPointLabelContainerStyle: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
            "backgroundColor": UIColor.white,
            "paddingHorizontal": 5,
            "paddingTop": 2,
            "paddingBottom": 0,
        ]
        let intermediateStopPointLabelStyle: [String: Any] = [
            "color": UIColor.darkText,
            "fontWeight": "bold",
            "fontSize": 12,
            "marginRight": 5,
        ]
    }

    private class DetailsFooterComponent: ViewComponent {
        var color: UIColor?

        override func render() -> NodeType {
            return ComponentNode(JourneyRoadmapSectionLayoutComponent(), in: self, props: { (component: JourneyRoadmapSectionLayoutComponent, hasKey: Bool) in
                component.styles = self.styles

                component.firstComponent = ComponentNode(ViewComponent(), in: self)

                component.secondComponent = ComponentNode(LineDiagramComponent(), in: self, props: { (component: LineDiagramComponent, hasKey: Bool) in
                    component.color = self.color
                })

                component.thirdComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.detailsFooterContentStyle
                })
            })
        }

        let detailsFooterContentStyle: [String: Any] = [
            "paddingBottom": 15,
        ]
    }

    // COMMON
    private class LineDiagramComponent: ViewComponent {
        var color: UIColor?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.lineDiagramContainerStyle
            }).add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.lineDiagramStyle
                    component.styles["backgroundColor"] = self.color!
                })
            ])
        }

        let lineDiagramContainerStyle: [String: Any] = [
            "backgroundColor": UIColor.white,
            "flexGrow": 1,
            "alignItems": YGAlign.center,
        ]
        var lineDiagramStyle: [String: Any] = [
            "flexGrow": 1,
            "width": 4,
        ]
    }

    private class LineDiagramForIntermediateStopPointComponent: ViewComponent {
        var color: UIColor?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.lineDiagramContainerStyle
            }).add(children: [
                ComponentNode(SubLineDiagramComponent(), in: self, props: { (component: SubLineDiagramComponent, hasKey: Bool) in
                    component.color = self.color
                }),
                ComponentNode(LineDiagramStopPointIconComponent(), in: self, props: { (component: LineDiagramStopPointIconComponent, hasKey: Bool) in
                    component.color = self.color
                    component.hasUpperJunction = true
                    component.hasLowerJunction = true
                    component.outerFontSize = 12
                    component.innerFontSize = 0
                }),
                ComponentNode(SubLineDiagramComponent(), in: self, props: { (component: SubLineDiagramComponent, hasKey: Bool) in
                    component.color = self.color
                }),
            ])
        }

        let lineDiagramContainerStyle: [String: Any] = [
            "backgroundColor": UIColor.white,
            "flexGrow": 1,
            "alignItems": YGAlign.center,
            "justifyContent": YGJustify.center,
        ]
    }
}
