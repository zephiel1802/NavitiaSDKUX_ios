//
//  ScrollViewComponent.swift
//  Pods
//
//  Created by Johan Rouve on 22/08/2017.
//
//

import Foundation
import Render

class ScrollViewComponent: StylizedComponent<NilState> {
    override func render() -> NodeType {
        return Node<UIScrollView>() { view, layout, size in
            layout.flex()
            self.applyStyles(view: view, layout: layout)
        }
    }
}
