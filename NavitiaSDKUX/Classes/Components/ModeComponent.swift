//
//  ModeComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 27/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render
import NavitiaSDK

class ModeComponent: ViewComponent {
    let modes: Modes = Modes()
    var section: Section?

    override func render() -> NodeType {
        let computedStyles = mergeDictionaries(dict1: iconStyles, dict2: self.styles)
        return ComponentNode(IconComponent(), in: self, props: {(component, _) in
            component.name = self.modes.getModeIcon(section: self.section!)
            component.styles = computedStyles
        })
    }
    
    let iconStyles = [
        "color": config.colors.darkerGray,
    ]
}
