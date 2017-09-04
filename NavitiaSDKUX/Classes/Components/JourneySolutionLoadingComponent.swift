//
//  JourneySolutionLoadingComponent.swift
//  RenderTest
//
//  Created by Johan Rouve on 17/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render
import NavitiaSDK

class JourneySolutionLoadingComponent: ViewComponent {
    
    required init() {
        super.init()
        defaultOptions = [.preventViewHierarchyDiff]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() -> NodeType {
        let computedStyles = mergeDictionaries(dict1: listStyles, dict2: self.styles)
        
        return ComponentNode(ListRowComponent(), in: self, props: {(component, hasKey: Bool) in
            component.styles = computedStyles
        }).add(children: [
            ComponentNode(ViewComponent(), in: self).add(children: [
                ComponentNode(ViewComponent(), in: self).add(children: [
                    ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
                        component.styles = self.journeyHeaderStyles
                    }).add(children: [
                        ShimComponent(width: 95, height: 17),
                        ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
                            component.styles = self.journeyDurationStyles
                        }).add(children: [
                            ShimComponent(width: 34, height: 26),
                            ShimComponent(width: 21, height: 12),
                        ])
                    ]),
                    ComponentNode(SeparatorComponent(), in: self),
                    ComponentNode(ViewComponent(), in: self, props: {(component, hasKey: Bool) in
                        component.styles = self.journeyFriezeStyle
                    }).add(children: [
                        FriezeShimComponent(duration: 87),
                        FriezeShimComponent(duration: 130),
                        FriezeShimComponent(duration: 115),
                    ]),
                    ShimComponent(width: 181, height: 17),
                ]),
            ])
        ])
    }
    
    func FriezeShimComponent(duration: Int) -> NodeType {
        return ShimComponent(){ view, layout, size in
            layout.flexGrow = CGFloat(duration)
            layout.height = CGFloat(45)
            layout.marginEnd = CGFloat(config.metrics.margin)
        }
    }
    
    func ShimComponent(width: Int, height: Int) -> NodeType {
        return ShimComponent(){ view, layout, size in
            layout.width = CGFloat(width)
            layout.height = CGFloat(height)
        }
    }
    
    func ShimComponent(props: @escaping Node<UIView>.PropsBlock = { _ in }) -> NodeType {
        return Node<UIView>{ view, layout, size in
            view.backgroundColor = config.colors.lighterGray
            props(view, layout, size)
        }
    }
    
    let listStyles: [String: Any] = [
        "backgroundColor": config.colors.white,
        "padding": config.metrics.marginL,
        "paddingTop": 4,
        "borderRadius": config.metrics.radius,
        "marginBottom": config.metrics.margin,
        "shadowRadius": 2.0,
        "shadowOpacity": 0.12,
        "shadowOffset": [0, 0],
        "shadowColor": UIColor.black,
    ]
    let journeyHeaderStyles: [String: Any] = [
        "flexDirection": YGFlexDirection.row,
        "alignItems": YGAlign.center,
        "justifyContent" : YGJustify.spaceBetween,
        "height": 46,
    ]
    let journeyDurationStyles: [String: Any] = [
        "alignSelf": YGAlign.stretch,
        "justifyContent" : YGJustify.spaceAround,
        "alignItems": YGAlign.flexEnd,
    ]
    let journeyFriezeStyle: [String: Any] = [
        "flexDirection": YGFlexDirection.row,
        "marginEnd": config.metrics.margin * -1,
        "alignItems": YGAlign.center,
        "justifyContent" : YGJustify.spaceBetween,
        "height": 77,
    ]
}
