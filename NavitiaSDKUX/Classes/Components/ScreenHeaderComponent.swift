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
        let headerStyles = [
            "marginTop": self.getMargin(),
        ]
        let computedStyles = mergeDictionaries(dict1: headerStyles, dict2: self.styles)
        return ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
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
