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
