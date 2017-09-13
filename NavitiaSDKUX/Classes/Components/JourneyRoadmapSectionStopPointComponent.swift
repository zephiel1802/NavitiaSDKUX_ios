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
            component.firstComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
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

                    component.text = timeText(isoString: dateTime!)
                })
            ])

            component.secondComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": getUIColorFromHexadecimal(hex: (self.section!.displayInformations?.color)!),
                    "flexGrow": 1,
                ]
            })

            component.thirdComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
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

                    component.text = stopPointLabel!
                })
            ])
        })
    }
}
