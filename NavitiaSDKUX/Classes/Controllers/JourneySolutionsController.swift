//
//  JourneySolutionsController.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//
import Render
import UIKit
import NavitiaSDK

public class JourneySolutionsController: ViewController, ComponentController {
    public struct InParameters {
        public init() {}
        
        public var originId: String?
        public var originLabel: String?
        public var destinationId: String?
        public var destinationLabel: String?
        public var datetime: Date?
        public var datetimeRepresents: JourneysRequestBuilder.DatetimeRepresents?
        public var modes: [String]?
        public var originModes: [String]?
        public var destinationModes: [String]?
        public var count: Int32?
        public var minJourneyCount: Int32?
        public var maxJourneyCount: Int32?
    }
    
    public var component = JourneySolutionsScreen()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("controller.JourneySolutionsController.title", bundle: bundle, comment: "Navigation bar title for journey solutions screen")
        addComponentToViewControllerHierarchy()
    }
    
    override open func viewDidLayoutSubviews() {
        renderComponent()
    }
    
    public func configureComponentProps() {
        component.navigationController = navigationController
    }
    
    open func setProps(with parameters: InParameters) {
        component.state.parameters = parameters
    }
    
    open func setProps(origin: Place, destination: Place) {
        var params: InParameters = InParameters()
        params.originId = origin.id!
        params.destinationId = destination.id!
        params.originLabel = origin.name!
        params.destinationLabel = destination.name!
        
        self.setProps(with: params)
    }
}

