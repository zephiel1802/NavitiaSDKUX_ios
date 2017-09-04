//
//  JourneySolutionsScreen.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render
import NavitiaSDK

public struct JourneySolutionsScreenState: StateType {
    public init() { }
    var origin: String = ""
    var originId: String = ""
    var destination: String = ""
    var destinationId: String = ""
    var journeys: Journeys? = nil
    var datetime: Date = Date()
    var loaded: Bool = false
    var error: Bool = false
}

open class JourneySolutionsScreen: StylizedComponent<JourneySolutionsScreenState> {
    var navitiaSDK: NavitiaSDK? = nil
    var navigationController: UINavigationController?
    
    required public init() {
        super.init()
                
        let navitiaConfig = NavitiaConfiguration(token: "9e304161-bb97-4210-b13d-c71eaf58961c")
        self.navitiaSDK = NavitiaSDK(configuration: navitiaConfig)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func render() -> NodeType {
        if !state.loaded {
            self.retrieveJourneys(originId: self.state.originId, destinationId: self.state.destinationId)
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
                        component.origin = self.state.origin.isEmpty ? self.state.originId : self.state.origin
                        component.destination = self.state.destination.isEmpty ? self.state.destinationId : self.state.destination
                    }),
                    ComponentNode(DateTimeButtonComponent(), in: self)
                ])
            ]),
            ComponentNode(ScrollViewComponent(), in: self).add(children: [
                ComponentNode(ListViewComponent(), in: self).add(children: resultComponents)
            ])
        ])
    }
    
    func retrieveJourneys(originId: String, destinationId: String) {
        navitiaSDK?.journeysApi.newJourneysRequestBuilder()
            .withFrom(originId)
            .withTo(destinationId)
            .withDatetime(getIsoDatetime(datetime: state.datetime))
            .get(completion: { journeys, error in
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
            results.append(ComponentNode(JourneySolutionComponent(), in: self, props: {(component, hasKey: Bool) in
                component.journey = journey
                component.navigationController = self.navigationController
            }))
            index += 1
        }
        return results
    }
    
    func extractLabelsFromJourneyResult(journey: Journey) {
        var origin = state.origin
        var destination = state.destination
        
        if (journey.sections?.isEmpty == false) {
            if state.origin.isEmpty {
                origin = (journey.sections![0].from?.name)!
            }
            if state.destination.isEmpty {
                destination = (journey.sections![journey.sections!.count - 1].from?.name)!
            }
        }
        
        self.setState { state in
            state.origin = origin
            state.destination = destination
        }
    }
    
    let headerStyles: [String: Any] = [
        "backgroundColor": config.colors.tertiary
    ]
}
