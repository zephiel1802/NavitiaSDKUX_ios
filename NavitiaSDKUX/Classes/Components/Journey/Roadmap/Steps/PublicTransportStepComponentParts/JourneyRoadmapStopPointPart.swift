import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts {
    class StopPointPart: ViewComponent {
        let JourneyRoadmap3ColumnsLayout: Components.Journey.Roadmap.Steps.JourneyRoadmap3ColumnsLayout.Type = Components.Journey.Roadmap.Steps.JourneyRoadmap3ColumnsLayout.self
        let StopPointIconPart: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.LineDiagram.StopPointIconPart.Type = Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.LineDiagram.StopPointIconPart.self
        let StopPointLabelPart: Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.StopPoint.StopPointLabelPart.Type = Components.Journey.Roadmap.Steps.PublicTransportStepComponentParts.StopPoint.StopPointLabelPart.self
        let TimePart: Components.Journey.Roadmap.Steps.Parts.TimePart.Type = Components.Journey.Roadmap.Steps.Parts.TimePart.self
        
        var section: Section?
        var sectionWay: SectionWay?
        var time: String?
        var color: UIColor?

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

            return ComponentNode(JourneyRoadmap3ColumnsLayout.init(), in: self, props: { (component, _) in
                component.leftChildren = [
                    ComponentNode(self.TimePart.init(), in: self, props: { (component, _) in
                        component.dateTime = (self.time != nil) ? self.time : dateTime
                    })
                ]
                component.middleChildren = [
                    ComponentNode(self.StopPointIconPart.init(), in: self, props: { (component, _) in
                        component.color = (self.color != nil) ? self.color! : getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(self.section!.displayInformations?.color))
                    })
                ]
                component.rightChildren = [
                    ComponentNode(self.StopPointLabelPart.init(), in: self, props: { (component, _) in
                        component.stopPointLabel = stopPointLabel
                    })
                ]
            })
        }
    }
}
