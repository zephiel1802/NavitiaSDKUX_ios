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
        public init(originId: String, destinationId: String) {
            self.originId = originId
            self.destinationId = destinationId
        }
        
        public var originId: String
        public var originLabel: String?
        public var destinationId: String
        public var destinationLabel: String?
        public var datetime: Date?
        public var datetimeRepresents: JourneysRequestBuilder.DatetimeRepresents?
        public var forbiddenUris: [String]?
        public var allowedId: [String]?
        public var firstSectionModes: [JourneysRequestBuilder.FirstSectionMode]?
        public var lastSectionModes: [JourneysRequestBuilder.LastSectionMode]?
        public var count: Int32?
        public var minNbJourneys: Int32?
        public var maxNbJourneys: Int32?
    }
    
    public var component = JourneySolutionsScreen()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("journeys", bundle: bundle, comment: "Navigation bar title for journey solutions screen")
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
}

