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
            component.firstComponent = ComponentNode(LabelComponent(), in: self, props: { (component, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": UIColor.white,
                    "color": config.colors.darkText,
                ]

                component.text = timeText(isoString: dateTime!)
            })
            component.secondComponent = ComponentNode(LabelComponent(), in: self, props: { (component, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": getUIColorFromHexadecimal(hex: (self.section!.displayInformations?.color)!),
                    "fontWeight": "bold",
                    "color": UIColor.white,
                ]

                component.text = "-"
            })
            component.thirdComponent = ComponentNode(LabelComponent(), in: self, props: { (component, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": config.colors.lighterGray,
                    "color": config.colors.darkText,
                    "fontWeight": "bold",
                    "fontSize": 16,
                    "paddingHorizontal": 5,
                    "paddingTop": 10,
                    "paddingBottom": 15,
                ]

                component.text = stopPointLabel!
            })
        })
    }
}
