import Foundation
import Render
import NavitiaSDK

enum SectionWay {
    case departure
    case arrival
}

class JourneyRoadmapSectionStopPointComponent: ViewComponent {
    var section: Section?
    var sectionWay: SectionWay?

    override func render() -> NodeType {
        var dateTime: String?
        var stopPointLabel: String?
        switch self.sectionWay! {
            case .departure:
                dateTime = self.section!.departureDateTime
                stopPointLabel = self.section!.from!.name
            case .arrival:
                dateTime = self.section!.arrivalDateTime
                stopPointLabel = self.section!.to!.name
        }

        return ComponentNode(JourneyRoadmapSectionLayoutComponent(), in: self, props: { (component: JourneyRoadmapSectionLayoutComponent, hasKey: Bool) in
            component.firstComponent = ComponentNode(TimeComponent(), in: self, props: { (component: TimeComponent, hasKey: Bool) in
                component.dateTime = dateTime
            })

            component.secondComponent = ComponentNode(LineDiagramComponent(), in: self, props: { (component: LineDiagramComponent, hasKey: Bool) in
                component.color = self.section!.displayInformations?.color
                component.sectionWay = self.sectionWay
            })

            component.thirdComponent = ComponentNode(DescriptionContentComponent(), in: self, props: { (component: DescriptionContentComponent, hasKey: Bool) in
                component.stopPointLabel = stopPointLabel
            })
        })
    }

    private class TimeComponent: ViewComponent {
        var dateTime: String?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": UIColor.white,
                    "paddingTop": 14,
                    "alignItems": YGAlign.center,
                    "justifyContent": YGJustify.center,
                ]
            }).add(children: [
                ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                    component.styles = [
                        "color": config.colors.darkText,
                        "fontSize": 12,
                        "numberOfLines": 1,
                        "lineBreakMode": NSLineBreakMode.byClipping,
                    ]

                    component.text = timeText(isoString: self.dateTime!)
                })
            ])
        }
    }

    private class LineDiagramComponent: ViewComponent {
        var color: String?
        var sectionWay: SectionWay?

        override func render() -> NodeType {
            let subComponents = [
                ComponentNode(EmptySubLineDiagramComponent(), in: self),
                ComponentNode(LineDiagramStopPointIconComponent(), in: self, props: { (component: LineDiagramStopPointIconComponent, hasKey: Bool) in
                    component.color = self.color
                    component.sectionWay = self.sectionWay
                }),
                ComponentNode(SubLineDiagramComponent(), in: self, props: { (component: SubLineDiagramComponent, hasKey: Bool) in
                    component.color = self.color
                }),
            ]

            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": UIColor.white,
                    "flexGrow": 1,
                    "alignItems": YGAlign.center,
                    "justifyContent": YGJustify.center,
                ]
            }).add(children: sectionWay == SectionWay.departure ? subComponents : subComponents.reversed())
        }
    }

    private class EmptySubLineDiagramComponent: ViewComponent {
        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "flexGrow": 1,
                ]
            })
        }
    }

    private class SubLineDiagramComponent: ViewComponent {
        var color: String?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": getUIColorFromHexadecimal(hex: self.color!),
                    "flexGrow": 1,
                    "width": 4,
                ]
            })
        }
    }

    private class LineDiagramStopPointIconComponent: ViewComponent {
        var color: String?
        var sectionWay: SectionWay?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "width": 20,
                    "height": 20,
                ]
            }).add(children: [
                ComponentNode(StopPointIconComponent(), in: self, props: { (component: StopPointIconComponent, hasKey: Bool) in
                    component.color = self.color
                }),
                ComponentNode(LineDiagramJunctionIconComponent(), in: self, props: { (component: LineDiagramJunctionIconComponent, hasKey: Bool) in
                    component.color = self.color
                    component.sectionWay = self.sectionWay
                }),
            ])
        }
    }

    private class StopPointIconComponent: ViewComponent {
        var color: String?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self).add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = [
                        "position": YGPositionType.absolute,
                        "top": 0,
                        "left": 0,
                        "width": 20,
                        "height": 20,
                        "alignItems": YGAlign.center,
                        "justifyContent": YGJustify.center,
                    ]
                }).add(children: [
                    ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, hasKey: Bool) in
                        component.name = "circle-filled"

                        component.styles = [
                            "color": getUIColorFromHexadecimal(hex: self.color!),
                            "fontSize": 18,
                        ]
                    })
                ]),
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = [
                        "position": YGPositionType.absolute,
                        "top": 0,
                        "left": 0,
                        "width": 20,
                        "height": 20,
                        "alignItems": YGAlign.center,
                        "justifyContent": YGJustify.center,
                    ]
                }).add(children: [
                    ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, hasKey: Bool) in
                        component.name = "circle-filled"

                        component.styles = [
                            "color": UIColor.white,
                            "fontSize": 12,
                        ]
                    })
                ])
            ])
        }
    }

    private class LineDiagramJunctionIconComponent: ViewComponent {
        var color: String?
        var sectionWay: SectionWay?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "position": YGPositionType.absolute,
                    (self.sectionWay == SectionWay.departure ? "bottom" : "top"): 0,
                    "left": 0,
                    "width": 20,
                    "height": 3,
                    "alignItems": YGAlign.center,
                    "justifyContent": YGJustify.center,
                ]
            }).add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = [
                        "backgroundColor": getUIColorFromHexadecimal(hex: self.color!),
                        "flexGrow": 1,
                        "width": 4,
                    ]
                })
            ])
        }
    }

    private class DescriptionContentComponent: ViewComponent {
        var stopPointLabel: String?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": config.colors.lighterGray,
                    "paddingHorizontal": 5,
                    "paddingTop": 14,
                    "paddingBottom": 18,
                ]
            }).add(children: [
                ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                    component.styles = [
                        "color": config.colors.darkText,
                        "fontWeight": "bold",
                        "fontSize": 15,
                        "numberOfLines": 0,
                        "lineBreakMode": NSLineBreakMode.byWordWrapping,
                    ]

                    component.text = self.stopPointLabel!
                })
            ])
        }
    }

}
