//
//  ButtonComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 27/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

class ButtonComponent: StylizedComponent<NilState> {
    var text: String = ""
    
    override func render() -> NodeType {
        return Node<UIButton>() { view, layout, _ in
            self.applyStyles(view: view, layout: layout)
        }
    }
}
