//
//  File.swift
//  RenderTest
//
//  Created by Thomas Noury on 27/07/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation
import Render

open class StylizedComponent<S:StateType>: ComponentView<S> {
    var styles: Dictionary<String, Any> = [:]
    var uniqueKey: String = "<empty!>"
    var bundle: Bundle = Bundle.main

    public required init() {
        super.init()
        bundle = Bundle.init(for: self.classForCoder)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyStyles(view: UIView, layout: YGLayout) {
        for (prop, value) in styles {
            switch prop {
            case "alpha": view.alpha = value as! CGFloat; break
            case "backgroundColor": view.backgroundColor = value as? UIColor; break
            case "borderRadius": view.cornerRadius = CGFloat(value as! Int); break
            case "direction": layout.direction = value as! YGDirection; break
            case "flexDirection": layout.flexDirection = value as! YGFlexDirection; break
            case "justifyContent": layout.justifyContent = value as! YGJustify; break
            case "alignContent": layout.alignContent = value as! YGAlign; break
            case "alignItems": layout.alignItems = value as! YGAlign; break
            case "alignSelf": layout.alignSelf = value as! YGAlign; break
            case "position": layout.position = value as! YGPositionType; break
            case "flexWrap": layout.flexWrap = value as! YGWrap; break
            case "overflow": layout.overflow = value as! YGOverflow; break
            case "display": layout.display = value as! YGDisplay; break
            case "flexGrow": layout.flexGrow = CGFloat(value as! Int); break
            case "flexShrink": layout.flexShrink = CGFloat(value as! Int); break
            case "flexBasis": layout.flexBasis = value as! CGFloat; break
            case "left": layout.left = CGFloat(value as! Int); break
            case "top": layout.top = CGFloat(value as! Int); break
            case "right": layout.right = CGFloat(value as! Int); break
            case "bottom": layout.bottom = CGFloat(value as! Int); break
            case "start": layout.start = CGFloat(value as! Int); break
            case "end": layout.end = CGFloat(value as! Int); break
            case "marginLeft": layout.marginLeft = CGFloat(value as! Int); break
            case "marginTop": layout.marginTop = CGFloat(value as! Int); break
            case "marginRight": layout.marginRight = CGFloat(value as! Int); break
            case "marginBottom": layout.marginBottom = CGFloat(value as! Int); break
            case "marginStart": layout.marginStart = CGFloat(value as! Int); break
            case "marginEnd": layout.marginEnd = CGFloat(value as! Int); break
            case "marginHorizontal": layout.marginHorizontal = CGFloat(value as! Int); break
            case "marginVertical": layout.marginVertical = CGFloat(value as! Int); break
            case "margin": layout.margin = CGFloat(value as! Int); break
            case "paddingLeft": layout.paddingLeft = CGFloat(value as! Int); break
            case "paddingTop": layout.paddingTop = CGFloat(value as! Int); break
            case "paddingRight": layout.paddingRight = CGFloat(value as! Int); break
            case "paddingBottom": layout.paddingBottom = CGFloat(value as! Int); break
            case "paddingStart": layout.paddingStart = CGFloat(value as! Int); break
            case "paddingEnd": layout.paddingEnd = CGFloat(value as! Int); break
            case "paddingHorizontal": layout.paddingHorizontal = CGFloat(value as! Int); break
            case "paddingVertical": layout.paddingVertical = CGFloat(value as! Int); break
            case "padding": layout.padding = CGFloat(value as! Int); break
            case "borderLeftWidth": layout.borderLeftWidth = CGFloat(value as! Int); break
            case "borderTopWidth": layout.borderTopWidth = CGFloat(value as! Int); break
            case "borderRightWidth": layout.borderRightWidth = CGFloat(value as! Int); break
            case "borderBottomWidth": layout.borderBottomWidth = CGFloat(value as! Int); break
            case "borderStartWidth": layout.borderStartWidth = CGFloat(value as! Int); break
            case "borderEndWidth": layout.borderEndWidth = CGFloat(value as! Int); break
            case "borderWidth": view.layer.borderWidth = CGFloat(value as! Int); break
            case "borderColor": view.layer.borderColor = (value as! UIColor).cgColor; break
            case "percent": layout.percent = value as! YGPercentLayout; break
            case "width": layout.width = CGFloat(value as! Int); break
            case "height": if let percent = value as? YGValue {
                layout.percent.height = percent;
            } else {
                layout.height = CGFloat(value as! Int);
            }
                break
            case "minWidth": layout.minWidth = CGFloat(value as! Int); break
            case "minHeight": layout.minHeight = CGFloat(value as! Int); break
            case "maxWidth": layout.maxWidth = CGFloat(value as! Int); break
            case "maxHeight": layout.maxHeight = CGFloat(value as! Int); break
            case "shadowRadius": view.layer.shadowRadius = CGFloat(value as! Double); break
            case "shadowOpacity": view.layer.shadowOpacity = Float(value as! Double); break
            case "shadowColor": view.layer.shadowColor = (value as AnyObject).cgColor; break
            case "shadowOffset":
                view.layer.masksToBounds = false;
                view.layer.shadowOffset = CGSize(width: 0, height: 0);
                break
            default: break
            }
        }
    }
}
