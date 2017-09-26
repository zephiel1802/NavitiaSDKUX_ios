import Foundation
import Render
import NavitiaSDK

enum SectionWay {
    case departure
    case arrival
}

class LineDiagramStopPointIconComponent: ViewComponent {
    var color: UIColor?
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

class DottedLineDiagramComponent: ViewComponent {
    private var lineWidth: CGFloat?
    private var pattern: [CGFloat]?
    private var dashPhase: CGFloat?
    private var color: UIColor?

    override func render() -> NodeType {
        return Node<DottedLineDiagramView>() { view, layout, _ in
            self.applyStyles(view: view, layout: layout)
            self.applyDottedLineDiagramStyles(view: view, layout: layout)
            view.createDottedLineShapeLayer(color: self.color!, lineWidth: self.lineWidth!, pattern: self.pattern!, dashPhase: self.dashPhase!)
        }
    }

    private func applyDottedLineDiagramStyles(view: DottedLineDiagramView, layout: YGLayout) {
        for (prop, value) in styles {
            switch prop {
            case "color": self.color = value as! UIColor; break
            case "lineWidth": self.lineWidth = CGFloat(value as! Int) ; break
            case "pattern": self.pattern = value as! [CGFloat]; break
            case "dashPhase": self.dashPhase =  CGFloat(value as! Int); break
            default: break
            }
        }
    }

    private class DottedLineDiagramView: UIView {
        private var path: UIBezierPath!

        public func createDottedLineShapeLayer(color: UIColor, lineWidth: CGFloat, pattern: [CGFloat], dashPhase: CGFloat) {
            path = UIBezierPath()

            path.move(to: CGPoint(x: self.frame.size.width*0.5, y: 0.0))
            path.addLine(to: CGPoint(x: self.frame.size.width*0.5, y: self.frame.size.height))

            let shapeLayer = CAShapeLayer()
            shapeLayer.path = self.path.cgPath

            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineDashPattern = pattern as [NSNumber]
            shapeLayer.lineDashPhase = dashPhase
            shapeLayer.lineWidth = lineWidth
            shapeLayer.lineCap = kCALineCapRound

            self.layer.addSublayer(shapeLayer)
        }
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
    var color: UIColor?

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
            component.styles = [
                "backgroundColor": self.color!,
                "flexGrow": 1,
                "width": 4,
            ]
        })
    }
}

private class StopPointIconComponent: ViewComponent {
    var color: UIColor?
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
                        "color": self.color!,
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
    var color: UIColor?
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
                    "backgroundColor": self.color!,
                    "flexGrow": 1,
                    "width": 4,
                ]
            })
        ])
    }
}
