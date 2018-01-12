//
//  ScreenHeaderComponent.swift
//  Pods
//
//  Created by Johan Rouve on 22/08/2017.
//
//

import Foundation
import Render

class ScreenHeaderComponent: StylizedComponent<NilState> {
    var navigationController: UINavigationController?
    
    override func render() -> NodeType {
        var computedStyles = self.styles
        let initialPaddingTop = (self.styles["paddingTop"] != nil) ? self.styles["paddingTop"] as! Int : 0
        computedStyles["paddingTop"] = initialPaddingTop + getMargin()
        return ComponentNode(ViewComponent(), in: self, props: {(component, _) in
            component.styles = computedStyles
        })
    }
    
    func getMargin() -> Int {
        if navigationController == nil {
            return 20
        } else {
            if navigationController?.navigationBar.isTranslucent == true {
                return 64
            } else {
                return 0
            }
        }
    }
}
