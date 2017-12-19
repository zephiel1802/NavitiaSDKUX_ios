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
        
        var journeyComponents: [NodeType] = []
        if state.journeys != nil {
            journeyComponents = self.getJourneyComponents(journeys: state.journeys!)
        } else {
            journeyComponents = Array(0..<4).map { _ in
                ComponentNode(JourneySolutionLoadingComponent(), in: self)
            }
        }
        
        var resultComponents: [NodeType] = []
        if state.error {
            resultComponents = [ComponentNode(AlertComponent(), in: self, props: {(component, hasKey: Bool) in
                component.text = NSLocalizedString("screen.JourneySolutionsScreen.error", bundle: self.bundle, comment: "No journeys")
            })]
        } else {
            resultComponents = journeyComponents
        }
        
        return ComponentNode(ScreenComponent(), in: self).add(children: [
            ComponentNode(ScreenHeaderComponent(), in: self, props: { (component, hasKey: Bool) in
                component.navigationController = self.navigationController
                component.styles = self.headerStyles
            }).add(children: [
                ComponentNode(ContainerComponent(), in: self).add(children: [
                    ComponentNode(JourneyFormComponent(), in: self, props: {(component, hasKey: Bool) in
                        component.origin = self.state.parameters.originId
                        if (self.state.parameters.originLabel != nil && !self.state.parameters.originLabel!.isEmpty) {
                            component.origin = self.state.parameters.originLabel!
                        }

                        component.destination = self.state.parameters.destinationId
                        if (self.state.parameters.destinationLabel != nil && !self.state.parameters.destinationLabel!.isEmpty) {
                            component.destination = self.state.parameters.destinationLabel!
                        }
                    }),
                    ComponentNode(DateTimeButtonComponent(), in: self, props: {(component: DateTimeButtonComponent, _) in
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
                ComponentNode(ListViewComponent(), in: self).add(children: resultComponents)
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
    
    func getJourneyComponents(journeys: Journeys) -> [NodeType] {
        var results: [NodeType] = []
        var index: Int32 = 0
        for journey in journeys.journeys! {
            results.append(ComponentNode(JourneySolutionComponent(), in: self, props: {(component: JourneySolutionComponent, hasKey: Bool) in
                component.journey = journey
                component.disruptions = journeys.disruptions
                component.navigationController = self.navigationController
            }))
            index += 1
        }
        return results
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
}
