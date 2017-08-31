//
//  JourneySolutionComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 26/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render
import NavitiaSDK

class JourneySolutionComponent: ViewComponent {
    var masterViewController: ViewController?
    var navigationController: UINavigationController?
    var journey: Journey = Journey()
    
    override func render() -> NodeType {
        let computedStyles = mergeDictionaries(dict1: listStyles, dict2: self.styles)
        let walkingDistance = getWalkingDistance(sections: journey.sections!)
        
        var container = ComponentNode(ListRowComponent(), in: self, props: { (component, hasKey: Bool) in
            component.styles = computedStyles
        })

        container.add(children: [
            ComponentNode(JourneySolutionRowComponent(), in: self, props: {(component, hasKey: Bool) in
                component.departureTime = self.journey.departureDateTime!
                component.arrivalTime = self.journey.arrivalDateTime!
                component.totalDuration = self.journey.duration
                component.walkingDuration = self.journey.durations?.walking
                component.walkingDistance = walkingDistance
                component.sections = self.journey.sections!
            })
        ])
        
        var actionContainer = Node<UIView> { [weak self] view, layout, size in
            view.onTap { [weak self] _ in
                var journeySolutionRoadBookController = JourneySolutionRoadBookController()
                journeySolutionRoadBookController.journey = self?.journey
                if (self?.navigationController != nil) {
                    self?.navigationController?.pushViewController(journeySolutionRoadBookController, animated: true)
                } else if (self?.masterViewController != nil) {
                    self?.masterViewController?.present(journeySolutionRoadBookController, animated: true)
                }
            }
        }
        
        return actionContainer.add(child: container)
    }
    
    func getWalkingDistance(sections: [Section]) -> Int32 {
        var distance: Int32 = 0
        for section in sections {
            if section.type == "street_network" && section.mode == "walking" {
                for segment in section.path! {
                    distance += segment.length!
                }
            }
        }
        return distance
    }
    
    let listStyles:[String: Any] = [
        "backgroundColor": config.colors.white,
        "padding": config.metrics.marginL,
        "paddingTop": 4,
        "borderRadius": config.metrics.radius,
        "marginBottom": config.metrics.margin,
        "shadowRadius": CGFloat(2),
        "shadowOpacity": 0.12,
        "shadowOffset": [0, 0],
        "shadowColor": UIColor.black,
    ]
}
