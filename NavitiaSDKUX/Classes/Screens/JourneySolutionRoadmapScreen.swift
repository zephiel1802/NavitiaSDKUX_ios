import Foundation
import Render
import NavitiaSDK

public struct JourneySolutionRoadmapState: StateType {
    public init() {
    }

    var journey: Journey?
    var disruptions: [Disruption]?
}

open class JourneySolutionRoadmapScreen: StylizedComponent<JourneySolutionRoadmapState> {
    let SectionComponent: Components.Journey.Roadmap.SectionComponent.Type = Components.Journey.Roadmap.SectionComponent.self
    var navigationController: UINavigationController?

    override open func render() -> NodeType {
        return ComponentNode(ScreenComponent(), in: self).add(children: [
            ComponentNode(ScreenHeaderComponent(), in: self, props: { (component: ScreenHeaderComponent, hasKey: Bool) in
                component.navigationController = self.navigationController
                component.styles = self.screenHeaderStyle
            }),
            ComponentNode(ContainerComponent(), in: self, props: { (component: ContainerComponent, hasKey: Bool) in
                component.styles = self.journeySolutionCard
            }).add(children: [
                ComponentNode(JourneySolutionComponent(), in: self, props: { (component: JourneySolutionComponent, hasKey: Bool) in
                    component.journey = self.state.journey!
                    component.disruptions = self.state.disruptions
                    component.isTouchable = false
                })
            ]),
            ComponentNode(ScrollViewComponent(), in: self).add(children: [
                ComponentNode(ListViewComponent(), in: self).add(children: getSectionComponents())
            ])
        ])
    }

    func getSectionComponents() -> [NodeType] {
        var sectionComponents: [NodeType] = []
        var sectionIndex: Int = 0
        for section in self.state.journey!.sections! {
            if section.type == "street_network" || section.type == "public_transport" || section.type == "waiting" {
                sectionComponents.append(
                    ComponentNode(self.SectionComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.SectionComponent, hasKey: Bool) in
                        component.section = section
                        if (section != nil) {
                            component.disruptions = section.getMatchingDisruptions(from: self.state.disruptions)
                        }
                        if section.type == "transfer" {
                            component.destinationSection = self.state.journey?.sections?[sectionIndex + 1]
                        } else if section.type == "street_network" {
                            var network: String = ""
                            if section.from?.poi != nil {
                                network = (section.from?.poi?.properties!["network"])!
                                component.departureTime = self.state.journey!.sections![sectionIndex - 1].departureDateTime!
                                component.arrivalTime = self.state.journey!.sections![sectionIndex + 1].arrivalDateTime!
                            }
                            component.label = self.getDistanceLabel(network: network, mode: section.mode!, distance: sectionLength(paths: section.path!))
                        }
                    })
                )
            }
            sectionIndex += 1
        }
        return sectionComponents
    }

    func getDistanceLabel(network: String?, mode: String, distance: Int32) -> String {
        let distanceLabel: String = distanceText(bundle: self.bundle, meters: distance)
        var resultDistanceLabel = ""
        switch mode {
        case "walking":
            resultDistanceLabel = String(format: NSLocalizedString("component.JourneyRoadmapSectionStreetNetworkDescriptionModeDistanceLabelComponent.mode.walking",
                bundle: self.bundle,
                comment: "StreetNetwork distance label for walking"),
                distanceLabel)
            break
        case "bike":
            if network == nil || network == "" {
                resultDistanceLabel = String(format: NSLocalizedString("component.JourneyRoadmapSectionStreetNetworkDescriptionModeDistanceLabelComponent.mode.bike",
                    bundle: self.bundle,
                    comment: "StreetNetwork distance label for bike"),
                    distanceLabel)
            } else {
                resultDistanceLabel = String(format: NSLocalizedString("component.JourneyRoadmapSectionStreetNetworkDescriptionModeDistanceLabelComponent.mode.bss",
                    bundle: self.bundle,
                    comment: "StreetNetwork distance label for bss"),
                    distanceLabel,
                    network!)
            }
            break
        case "car":
            resultDistanceLabel = String(format: NSLocalizedString("component.JourneyRoadmapSectionStreetNetworkDescriptionModeDistanceLabelComponent.mode.car",
                bundle: self.bundle,
                comment: "StreetNetwork distance label for car"),
                distanceLabel)
            break
        default:
            break
        }
        return resultDistanceLabel
    }

    let screenHeaderStyle: [String: Any] = [
        "backgroundColor": config.colors.tertiary,
        "paddingTop": 40
    ]
    let journeySolutionCard: [String: Any] = [
        "marginTop": -40
    ]
}
