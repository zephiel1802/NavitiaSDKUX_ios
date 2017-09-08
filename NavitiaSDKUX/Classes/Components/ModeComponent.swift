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
    var section: Section?

    override func render() -> NodeType {
        let computedStyles = mergeDictionaries(dict1: iconStyles, dict2: self.styles)
        return ComponentNode(IconComponent(), in: self, props: {(component, hasKey: Bool) in
            component.name = self.getModeIcon(section: self.section!)
            component.styles = computedStyles
        })
    }
    
    let iconStyles = [
        "color": config.colors.darkerGray,
    ]

    func getModeIcon(section: Section) -> String {
        switch section.type! {
        case "public_transport": return getPhysicalMode(links: section.links!)
        case "transfer": return section.transferType!
        case "waiting": return section.type!
        default: return section.mode!
        }
    }

    func getPhysicalMode(links: [LinkSchema]) -> String {
        let id = getPhysicalModeId(links: links)
        var modeData = id.characters.split(separator: ":").map(String.init)
        return modeData[1].lowercased()
    }

    func getPhysicalModeId(links: [LinkSchema]) -> String {
        for link in links {
            if link.type == "physical_mode" {
                return link.id!
            }
        }
        return "<not_found>"
    }
}
