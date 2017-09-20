import Foundation
import Render
import NavitiaSDK



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
                    "flexGrow": 1,
                    "alignItems": YGAlign.center,
                    "justifyContent": YGJustify.center,
                ]
            }).add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = [
                        "flexGrow": 1,
                    ]
                }),
                ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                    component.styles = [
                        "color": config.colors.darkText,
                        "fontSize": 12,
                        "numberOfLines": 1,
                        "lineBreakMode": NSLineBreakMode.byClipping,
                    ]

                    component.text = timeText(isoString: self.dateTime!)
                }),
                ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = [
                        "flexGrow": 1,
                    ]
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
                    if (self.sectionWay != nil && self.sectionWay! == SectionWay.departure) {
                        component.hasUpperJunction = false
                        component.hasLowerJunction = true
                    }
                    if (self.sectionWay != nil && self.sectionWay! == SectionWay.arrival) {
                        component.hasUpperJunction = true
                        component.hasLowerJunction = false
                    }
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
