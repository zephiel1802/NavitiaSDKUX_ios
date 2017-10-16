import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections {
    class StopPointComponent: ViewComponent {
        let SectionLayoutComponent = Components.Journey.Roadmap.Sections.SectionLayoutComponent.self
        let StopPointIconComponent = Components.Journey.Roadmap.Sections.LineDiagram.StopPointIconComponent.self
        let PlaceComponent = Components.Journey.Roadmap.Sections.StopPoint.PlaceComponent.self
        let TimeComponent = Components.Journey.Roadmap.Sections.StopPoint.TimeComponent.self
        
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

            return ComponentNode(SectionLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionLayoutComponent, hasKey: Bool) in
                component.header = ComponentNode(self.TimeComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.StopPoint.TimeComponent, hasKey: Bool) in
                    component.dateTime = dateTime
                })
                component.body = ComponentNode(self.StopPointIconComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.LineDiagram.StopPointIconComponent, hasKey: Bool) in
                    component.color = getUIColorFromHexadecimal(hex: getHexadecimalColorWithFallback(self.section!.displayInformations?.color))
                })
                component.footer = ComponentNode(self.PlaceComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.StopPoint.PlaceComponent, hasKey: Bool) in
                    component.stopPointLabel = stopPointLabel
                })
            })
        }
    }
}
