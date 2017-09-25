import Foundation
import Render
import NavitiaSDK



class JourneyRoadmapSectionTransferStopPointComponent: ViewComponent {
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
                component.color = getUIColorFromHexadecimal(hex: "808080")
                component.sectionWay = self.sectionWay
            })

            component.thirdComponent = ComponentNode(DescriptionContentComponent(), in: self, props: { (component: DescriptionContentComponent, hasKey: Bool) in
                component.stopPointLabel = stopPointLabel
            })
        })
    }

    private class LineDiagramComponent: ViewComponent {
        var color: UIColor?
        var sectionWay: SectionWay?

        override func render() -> NodeType {
            let subComponents = [
                ComponentNode(EmptySubLineDiagramComponent(), in: self),
                ComponentNode(LineDiagramStopPointIconComponent(), in: self, props: { (component: LineDiagramStopPointIconComponent, hasKey: Bool) in
                    component.color = self.color
                    if (self.sectionWay != nil && self.sectionWay! == SectionWay.departure) {
                        component.hasUpperJunction = false
                        component.hasLowerJunction = false
                    }
                    if (self.sectionWay != nil && self.sectionWay! == SectionWay.arrival) {
                        component.hasUpperJunction = false
                        component.hasLowerJunction = false
                    }
                }),
                ComponentNode(DottedLineDiagramComponent(), in: self, props: { (component: DottedLineDiagramComponent, hasKey: Bool) in
                    component.styles = [
                        "flexGrow": 1,
                    ]

                    component.color = getUIColorFromHexadecimal(hex: "808080")
                    component.lineWidth = 6
                    component.pattern = [0, 12]
                    component.dashPhase = 6
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

    private class DescriptionContentComponent: ViewComponent {
        var stopPointLabel: String?

        override func render() -> NodeType {
            return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": config.colors.lighterGray,
                    "paddingHorizontal": 5,
                    "paddingTop": 14,
                    "paddingBottom": 14,
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
