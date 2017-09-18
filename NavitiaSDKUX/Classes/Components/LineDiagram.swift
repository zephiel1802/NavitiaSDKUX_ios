import Foundation
import Render
import NavitiaSDK

enum SectionWay {
    case departure
    case arrival
}

class LineDiagramStopPointIconComponent: ViewComponent {
    var color: String?
    var hasUpperJunction: Bool = false
    var hasLowerJunction: Bool = false
    var outerFontSize: Int = 18
    var innerFontSize: Int = 12

    override func render() -> NodeType {
        var subComponents: [NodeType] = []

        if (self.hasUpperJunction) {
            subComponents.append(ComponentNode(LineDiagramJunctionIconComponent(), in: self, props: { (component: LineDiagramJunctionIconComponent, hasKey: Bool) in
                component.color = self.color
                component.hasUpperJunction = true
            }))
        }
        if (self.hasLowerJunction) {
            subComponents.append(ComponentNode(LineDiagramJunctionIconComponent(), in: self, props: { (component: LineDiagramJunctionIconComponent, hasKey: Bool) in
                component.color = self.color
                component.hasLowerJunction = true
            }))
        }
        subComponents.append(ComponentNode(StopPointIconComponent(), in: self, props: { (component: StopPointIconComponent, hasKey: Bool) in
            component.color = self.color
            component.outerFontSize = self.outerFontSize
            component.innerFontSize = self.innerFontSize
        }))

        return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
            component.styles = [
                "width": 20,
                "height": 20,
            ]
        }).add(children: subComponents)
    }
}

class EmptySubLineDiagramComponent: ViewComponent {
    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
            component.styles = [
                "flexGrow": 1,
            ]
        })
    }
}

class SubLineDiagramComponent: ViewComponent {
    var color: String?

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
            component.styles = [
                "backgroundColor": getUIColorFromHexadecimal(hex: self.color!),
                "flexGrow": 1,
                "width": 4,
            ]
        })
    }
}

private class StopPointIconComponent: ViewComponent {
    var color: String?
    var outerFontSize: Int = 18
    var innerFontSize: Int = 12

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self).add(children: [
            ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "position": YGPositionType.absolute,
                    "top": 0,
                    "left": 0,
                    "width": 20,
                    "height": 20,
                    "alignItems": YGAlign.center,
                    "justifyContent": YGJustify.center,
                ]
            }).add(children: [
                ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, hasKey: Bool) in
                    component.name = "circle-filled"

                    component.styles = [
                        "color": getUIColorFromHexadecimal(hex: self.color!),
                        "fontSize": self.outerFontSize,
                    ]
                })
            ]),
            ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "position": YGPositionType.absolute,
                    "top": 0,
                    "left": 0,
                    "width": 20,
                    "height": 20,
                    "alignItems": YGAlign.center,
                    "justifyContent": YGJustify.center,
                ]
            }).add(children: [
                ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, hasKey: Bool) in
                    component.name = "circle-filled"

                    component.styles = [
                        "color": UIColor.white,
                        "fontSize": self.innerFontSize,
                    ]
                })
            ])
        ])
    }
}

private class LineDiagramJunctionIconComponent: ViewComponent {
    var color: String?
    var hasUpperJunction: Bool = false
    var hasLowerJunction: Bool = false

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
            component.styles = [
                "position": YGPositionType.absolute,
                "left": 0,
                "width": 20,
                "height": 10,
                "alignItems": YGAlign.center,
                "justifyContent": YGJustify.center,
            ]
            if (self.hasUpperJunction) {
                component.styles["top"] = 0
            } else
            if (self.hasLowerJunction) {
                component.styles["bottom"] = 0
            }
        }).add(children: [
            ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = [
                    "backgroundColor": getUIColorFromHexadecimal(hex: self.color!),
                    "flexGrow": 1,
                    "width": 4,
                ]
            })
        ])
    }
}