import Foundation
import Render
import NavitiaSDK

public struct JourneySolutionsScreenState: StateType {
    public init() { }
    var parameters: JourneySolutionsController.InParameters = JourneySolutionsController.InParameters(originId: "", destinationId: "")
    var journeys: Journeys? = nil
    var loaded: Bool = false
    var error: Bool = false
}

open class JourneySolutionsScreen: StylizedComponent<JourneySolutionsScreenState> {
    let AlertComponent:Components.Journey.Results.AlertComponent.Type = Components.Journey.Results.AlertComponent.self
    let DateTimeButtonComponent:Components.Journey.Results.DateTimeButtonComponent.Type = Components.Journey.Results.DateTimeButtonComponent.self
    let JourneyFormComponent:Components.Journey.Results.JourneyFormComponent.Type = Components.Journey.Results.JourneyFormComponent.self
    let JourneyLoadingComponent:Components.Journey.Results.JourneyLoadingComponent.Type = Components.Journey.Results.JourneyLoadingComponent.self
    let JourneySolutionComponent: Components.Journey.Results.JourneySolutionComponent.Type = Components.Journey.Results.JourneySolutionComponent.self
    let SeparatorPart:Components.Journey.Results.Parts.SeparatorPart.Type = Components.Journey.Results.Parts.SeparatorPart.self
    
    var navitiaSDK: NavitiaSDK? = nil
    var navigationController: UINavigationController?
    
    required public init() {
        super.init()
                
        let navitiaConfig = NavitiaConfiguration(token: NavitiaSDKUXConfig.getToken())
        self.navitiaSDK = NavitiaSDK(configuration: navitiaConfig)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func render() -> NodeType {
        if !state.loaded {
            self.retrieveJourneys(with: self.state.parameters)
        }
        
        var classicJourneyComponents: [NodeType] = []
        var ridesharingJourneyComponents: [NodeType] = []
        if state.journeys != nil {
            for journey in state.journeys!.journeys! {
                if journey.tags != nil && journey.tags!.contains("ridesharing") {
                    ridesharingJourneyComponents.append(ComponentNode(JourneySolutionComponent.init(), in: self, props: {(component, _) in
                        component.journey = journey
                        component.disruptions = self.state.journeys!.disruptions
                        component.navigationController = self.navigationController
                        component.hasArrow = false
                        component.isRidesharingComponent = true
                    }))
                } else {
                    classicJourneyComponents.append(ComponentNode(JourneySolutionComponent.init(), in: self, props: {(component, _) in
                        component.journey = journey
                        component.disruptions = self.state.journeys!.disruptions
                        component.navigationController = self.navigationController
                    }))
                }
            }
        } else {
            classicJourneyComponents = Array(0..<4).map { _ in
                ComponentNode(JourneyLoadingComponent.init(), in: self)
            }
            ridesharingJourneyComponents = Array(0..<2).map { _ in
                ComponentNode(JourneyLoadingComponent.init(), in: self)
            }
        }
        
        var classicJourneyResultComponents: [NodeType] = []
        var ridesharingJourneyResultComponents: [NodeType] = []
        if state.error {
            classicJourneyResultComponents = [ComponentNode(AlertComponent.init(), in: self, props: {(component, _) in
                component.text = NSLocalizedString("no_journey_found", bundle: self.bundle, comment: "No classic journeys")
            })]
            ridesharingJourneyResultComponents = [ComponentNode(AlertComponent.init(), in: self, props: {(component, _) in
                component.text = NSLocalizedString("no_carpooling_options_found", bundle: self.bundle, comment: "No ridesharing journeys")
            })]
        } else {
            if classicJourneyComponents.count > 0 {
                classicJourneyResultComponents = classicJourneyComponents
            } else {
                classicJourneyResultComponents = [ComponentNode(AlertComponent.init(), in: self, props: {(component, _) in
                    component.text = NSLocalizedString("no_journey_found", bundle: self.bundle, comment: "No classic journeys")
                })]
            }
            
            if ridesharingJourneyComponents.count > 0 {
                ridesharingJourneyResultComponents = ridesharingJourneyComponents
            } else {
                ridesharingJourneyResultComponents = [ComponentNode(AlertComponent.init(), in: self, props: {(component, _) in
                    component.text = NSLocalizedString("no_carpooling_options_found", bundle: self.bundle, comment: "No ridesharing journeys")
                })]
            }
        }
        
        return ComponentNode(ScreenComponent(), in: self).add(children: [
            ComponentNode(ScreenHeaderComponent(), in: self, props: { (component, _) in
                component.navigationController = self.navigationController
                component.styles = self.headerStyles
            }).add(children: [
                ComponentNode(ContainerComponent(), in: self).add(children: [
                    ComponentNode(JourneyFormComponent.init(), in: self, props: {(component, _) in
                        component.origin = self.state.parameters.originId
                        if (self.state.parameters.originLabel != nil && !self.state.parameters.originLabel!.isEmpty) {
                            component.origin = self.state.parameters.originLabel!
                        }

                        component.destination = self.state.parameters.destinationId
                        if (self.state.parameters.destinationLabel != nil && !self.state.parameters.destinationLabel!.isEmpty) {
                            component.destination = self.state.parameters.destinationLabel!
                        }
                    }),
                    ComponentNode(DateTimeButtonComponent.init(), in: self, props: {(component, _) in
                        if (self.state.parameters.datetime != nil) {
                            component.datetime = self.state.parameters.datetime
                        } else {
                            component.datetime = Date()
                        }
                        if (self.state.parameters.datetimeRepresents != nil) {
                            component.datetimeRepresents = self.state.parameters.datetimeRepresents!
                        } else {
                            component.datetimeRepresents = .departure
                        }
                    }),
                ])
            ]),
            ComponentNode(ScrollViewComponent(), in: self).add(children: [
                ComponentNode(ListViewComponent(), in: self).add(children: classicJourneyResultComponents),
                ComponentNode(TextComponent(), in: self, props: {(component, _) in
                    component.text = NSLocalizedString("carpooling", bundle: self.bundle, comment: "Carpooling").uppercased()
                    component.styles = self.ridesharingHeaderStyles
                }),
                ComponentNode(SeparatorPart.init(), in: self, props: {(component, _) in
                    component.styles = self.ridesharingSeparatorStyles
                }),
                ComponentNode(ListViewComponent(), in: self).add(children: ridesharingJourneyResultComponents)
            ])
        ])
    }
    
    func retrieveJourneys(with parameters: JourneySolutionsController.InParameters) {
        let journeyRequestBuilder: JourneysRequestBuilder = navitiaSDK!.journeysApi.newJourneysRequestBuilder()
        journeyRequestBuilder.withFrom(parameters.originId)
        journeyRequestBuilder.withTo(parameters.destinationId)

        if parameters.datetime != nil {
            journeyRequestBuilder.withDatetime(parameters.datetime!)
        }
        if parameters.datetimeRepresents != nil {
            journeyRequestBuilder.withDatetimeRepresents(parameters.datetimeRepresents!)
        }
        if parameters.forbiddenUris != nil {
            journeyRequestBuilder.withForbiddenUris(parameters.forbiddenUris!)
        }
        if parameters.allowedId != nil {
            journeyRequestBuilder.withAllowedId(parameters.allowedId!)
        }
        if parameters.firstSectionModes != nil {
            journeyRequestBuilder.withFirstSectionMode(parameters.firstSectionModes!)
        }
        if parameters.lastSectionModes != nil {
            journeyRequestBuilder.withLastSectionMode(parameters.lastSectionModes!)
        }
        if parameters.count != nil {
            journeyRequestBuilder.withCount(parameters.count!)
        }
        if parameters.minNbJourneys != nil {
            journeyRequestBuilder.withMinNbJourneys(parameters.minNbJourneys!)
        }
        if parameters.maxNbJourneys != nil {
            journeyRequestBuilder.withMaxNbJourneys(parameters.maxNbJourneys!)
        }

        journeyRequestBuilder.get(completion: { journeys, error in
            if error != nil {
                NSLog(error.debugDescription)
                self.setState { state in
                    state.error = true
                }
            } else {
                // Journeys successfuly fetched, we store them in the screen state
                // This will re-render the screen component (render method called)
                self.setState { state in
                    state.journeys = journeys
                    state.error = false
                }
                
                if (journeys?.journeys?.isEmpty == false) {
                    self.extractLabelsFromJourneyResult(journey: (journeys?.journeys![0])!)
                }
            }
            
            self.setState { state in
                state.loaded = true
            }
        })
    }
    
    func extractLabelsFromJourneyResult(journey: Journey) {
        var origin: String? = state.parameters.originLabel
        var destination: String? = state.parameters.destinationLabel
        
        if (journey.sections?.isEmpty == false) {
            if (state.parameters.originLabel == nil || state.parameters.originLabel!.isEmpty) {
                origin = (journey.sections![0].from?.name)!
            }
            if (state.parameters.destinationLabel == nil ||  state.parameters.destinationLabel!.isEmpty) {
                destination = (journey.sections![journey.sections!.count - 1].from?.name)!
            }
        }
        
        self.setState { state in
            state.parameters.originLabel = origin
            state.parameters.destinationLabel = destination
        }
    }
    
    let headerStyles: [String: Any] = [
        "backgroundColor": config.colors.tertiary,
    ]
    let ridesharingHeaderStyles: [String: Any] = [
        "color": config.colors.darkGray,
        "fontSize": 12,
        "fontWeight": "bold",
        "marginLeft": 10,
        "marginBottom": 2,
        "marginTop": 10,
    ]
    let ridesharingSeparatorStyles: [String: Any] = [
        "marginHorizontal": 10,
        "marginVertical": 5,
        "backgroundColor": config.colors.ridesharingSeparatorColor,
    ]
}
