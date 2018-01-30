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
    let StepComponent: Components.Journey.Roadmap.StepComponent.Type = Components.Journey.Roadmap.StepComponent.self
    let PlaceStepComponent: Components.Journey.Roadmap.Steps.PlaceStepComponent.Type = Components.Journey.Roadmap.Steps.PlaceStepComponent.self
    let JourneySolutionComponent: Components.Journey.Results.JourneySolutionComponent.Type = Components.Journey.Results.JourneySolutionComponent.self
    
    var navigationController: UINavigationController?
    
    open override func componentDidMount() {
        self.update()
        for childComponentView in self.childrenComponent.enumerated() {
            if let mapViewComponent = childComponentView.element.value as? JourneyMapViewComponent {
                mapViewComponent.componentDidMount()
            }
        }
    }
    
    override open func render() -> NodeType {
        return ComponentNode(ScreenComponent(), in: self).add(children: [
            ComponentNode(ScreenHeaderComponent(), in: self, props: { (component, _) in
                component.navigationController = self.navigationController
                component.styles = self.screenHeaderStyle
            }),
            Node<UIView>() { view, layout, size in
                layout.height = 0.4 * size.height
            }.add(children: [
                ComponentNode(JourneyMapViewComponent(), in: self, props: { (component, _) in
                    component.styles = self.mapViewStyles
                    component.journey = self.state.journey
                })
            ]),
            ComponentNode(ScrollViewComponent(), in: self).add(children: [
                ComponentNode(ContainerComponent(), in: self).add(children: [
                    ComponentNode(JourneySolutionComponent.init(), in: self, props: { (component, _) in
                        component.journey = self.state.journey!
                        component.disruptions = self.state.disruptions
                        component.isTouchable = false
                    })
                ]),
                ComponentNode(ListViewComponent(), in: self).add(children: getSectionComponents())
            ])
        ])
    }

    func getSectionComponents() -> [NodeType] {
        var sectionComponents: [NodeType] = []
        
        let journey = self.state.journey!
        let disruptions = self.state.disruptions ?? []
        
        let lastIndex = journey.sections!.count - 1
        for (index, section) in journey.sections!.enumerated() {
            if index == 0 {
                sectionComponents.append(
                    ComponentNode(self.PlaceStepComponent.init(), in: self, props: {(component, _) in
                        component.styles = self.originSectionStyles
                        component.datetime = journey.departureDateTime
                        component.placeType = NSLocalizedString("departure_with_colon", bundle: self.bundle, comment: "")
                        component.placeLabel = section.from?.name!
                        component.backgroundColorProp = config.colors.origin
                    })
                )
            }
            
            if section.type == "street_network" || section.type == "public_transport" || section.type == "transfer" {
                sectionComponents.append(
                    ComponentNode(self.StepComponent.init(), in: self, props: { (component, _) in
                        component.section = section
                        
                        if section.type == "public_transport" {
                            if index > 0 {
                                let prevSection = journey.sections![index - 1]
                                if prevSection.type == "waiting" {
                                    component.waitingTime = prevSection.duration
                                }
                            }
                            
                            if disruptions.count > 0 {
                                component.disruptions = section.getMatchingDisruptions(from: disruptions)
                            }
                        } else if section.type == "street_network" {
                            let mode = section.mode!
                            var network: String?
                            if index > 0 {
                                let prevSection = journey.sections![index - 1]
                                if prevSection.type == "bss_rent" {
                                    network = ""
                                    if let poi = section.from?.poi, let networkProp = poi.properties?["network"] {
                                        network = networkProp
                                    }
                                    component.isBSS = true
                                }
                            }
                            component.descriptionProp = self.getDescriptionLabel(mode: mode, duration: section.duration!, toLabel: section.to!.name!, network: network, fromLabel: section.from?.name!)
                        } else if section.type == "transfer" {
                            let mode = section.transferType!
                            component.descriptionProp = self.getDescriptionLabel(mode: mode, duration: section.duration!, toLabel: section.to!.name!)
                        }
                    })
                )
            }
            
            if index == lastIndex {
                sectionComponents.append(
                    ComponentNode(self.PlaceStepComponent.init(), in: self, props: {(component, _) in
                        component.styles = self.destinationSectionStyles
                        component.datetime = journey.arrivalDateTime
                        component.placeType = NSLocalizedString("arrival_with_colon", bundle: self.bundle, comment: "")
                        component.placeLabel = section.to?.name!
                        component.backgroundColorProp = config.colors.destination
                    })
                )
            }
        }
        return sectionComponents
    }

    func getDescriptionLabel(mode: String, duration: Int32, toLabel: String) -> NSMutableAttributedString {
        return self.getDescriptionLabel(mode: mode, duration: duration, toLabel: toLabel, network: nil, fromLabel: nil)
    }
    
    func getDescriptionLabel(mode: String, duration: Int32, toLabel: String, network: String?, fromLabel: String?) -> NSMutableAttributedString {
        let durationLabel: String = durationText(bundle: self.bundle, seconds: duration, useFullFormat: true)
        let descriptionLabel = NSMutableAttributedString.init()
        
        if network != nil {
            let takeStringTemplate = NSLocalizedString("take_a_bike_at", bundle: self.bundle, comment: "") + " "
            let take = String(format: takeStringTemplate, network!)
            descriptionLabel.append(NSAttributedString.init(string: take))
            
            let departureSpannableString = NSAttributedString.init(string: fromLabel!, attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat.init(config.metrics.text), weight: UIFontWeightBold)
            ])
            descriptionLabel.append(departureSpannableString)
            
            let inDirection = " " + NSLocalizedString("to", bundle: self.bundle, comment: "") + " "
            descriptionLabel.append(NSAttributedString.init(string: inDirection))
        } else {
            let to = NSLocalizedString("to_with_uppercase", bundle: self.bundle, comment: "") + " "
            descriptionLabel.append(NSAttributedString.init(string: to))
        }
        
        let toSpannableString = NSAttributedString.init(string: toLabel, attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat.init(config.metrics.text), weight: UIFontWeightBold)
            ])
        descriptionLabel.append(toSpannableString)
        
        var durationString = "\n"
        switch mode {
        case "walking":
            let walkingStringTemplate = NSLocalizedString("a_time_walk", bundle: self.bundle, comment: "")
            durationString += String(format: walkingStringTemplate, durationLabel)
            break
        case "bike":
            let bikeStringTemplate = NSLocalizedString("a_time_ride", bundle: self.bundle, comment: "")
            durationString += String(format: bikeStringTemplate, durationLabel)
            break
        case "car":
            let carStringTemplate = NSLocalizedString("a_time_drive", bundle: self.bundle, comment: "")
            durationString += String(format: carStringTemplate, durationLabel)
            break
        default:
            break
        }
        descriptionLabel.append(NSAttributedString.init(string: durationString))
        
        return descriptionLabel
    }

    let screenHeaderStyle: [String: Any] = [
        "backgroundColor": config.colors.tertiary,
        "height": 20,
    ]
    let mapViewStyles: [String: Any] = [
        "flexGrow": 1,
    ]
    let originSectionStyles: [String: Any] = [
        "marginBottom": config.metrics.margin,
    ]
    let destinationSectionStyles: [String: Any] = [
        "marginTop": config.metrics.margin,
    ]
}
