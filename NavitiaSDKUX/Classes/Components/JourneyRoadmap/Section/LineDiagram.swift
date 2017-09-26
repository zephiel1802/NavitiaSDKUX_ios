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
            component.styles = self.stopPointIconWithJunctionContainerStyle
        }).add(children: subComponents)
    }

    let stopPointIconWithJunctionContainerStyle: [String: Any] = [
        "width": 20,
        "height": 20,
    ]
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

class SubLineDiagramComponent: ViewComponent {
    var color: UIColor?

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
            component.styles = self.sublineDiagramStyle
            component.styles["backgroundColor"] = self.color!
        })
    }

    let sublineDiagramStyle: [String: Any] = [
        "flexGrow": 1,
        "width": 4,
    ]
}

private class StopPointIconComponent: ViewComponent {
    var color: UIColor?
    var outerFontSize: Int = 18
    var innerFontSize: Int = 12

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self).add(children: [
            ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.stopPointIconContainerStyle
            }).add(children: [
                ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, hasKey: Bool) in
                    component.styles["color"] = self.color!
                    component.styles["fontSize"] = self.outerFontSize
                    component.name = "circle-filled"
                })
            ]),
            ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.circleContainerStyle
            }).add(children: [
                ComponentNode(IconComponent(), in: self, props: { (component: IconComponent, hasKey: Bool) in
                    component.styles = self.circleStyle
                    component.styles["fontSize"] = self.innerFontSize
                    component.name = "circle-filled"
                })
            ])
        ])
    }

    let stopPointIconContainerStyle: [String: Any] = [
        "position": YGPositionType.absolute,
        "top": 0,
        "left": 0,
        "width": 20,
        "height": 20,
        "alignItems": YGAlign.center,
        "justifyContent": YGJustify.center,
    ]
    let circleContainerStyle: [String: Any] = [
        "position": YGPositionType.absolute,
        "top": 0,
        "left": 0,
        "width": 20,
        "height": 20,
        "alignItems": YGAlign.center,
        "justifyContent": YGJustify.center,
    ]
    let circleStyle: [String: Any] = [
        "color": UIColor.white,
    ]
}

private class LineDiagramJunctionIconComponent: ViewComponent {
    var color: UIColor?
    var hasUpperJunction: Bool = false
    var hasLowerJunction: Bool = false

    override func render() -> NodeType {
        return ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
            component.styles = self.junctionContainerStyle
            if (self.hasUpperJunction) {
                component.styles["top"] = 0
            } else
            if (self.hasLowerJunction) {
                component.styles["bottom"] = 0
            }
        }).add(children: [
            ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.junctionStyle
                component.styles["backgroundColor"] = self.color!

            })
        ])
    }

    let junctionContainerStyle: [String: Any] = [
        "position": YGPositionType.absolute,
        "left": 0,
        "width": 20,
        "height": 10,
        "alignItems": YGAlign.center,
        "justifyContent": YGJustify.center,
    ]
    let junctionStyle: [String: Any] = [
        "flexGrow": 1,
        "width": 4,
    ]
}
