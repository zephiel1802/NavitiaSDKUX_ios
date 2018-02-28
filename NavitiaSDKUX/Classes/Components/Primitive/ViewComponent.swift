//
//  ViewComponent.swift
//  RenderTest
//
//  Created by Thomas Noury on 27/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation

class ViewComponent: StylizedComponent<NilState> {
    override func render() -> NodeType {
        return Node<UIView>() { view, layout, size in
            self.applyStyles(view: view, layout: layout)
        }
    }
}
