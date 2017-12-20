import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.LineDiagram {
    class DottedComponent: ViewComponent {
        var color: UIColor?
        
        override func render() -> NodeType {
            return ComponentNode(DottedLineDiagramComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                component.styles = self.lineDiagramStyle
            })
        }
        
        var lineDiagramStyle: [String: Any] = [
            "start": 58,
            "width": 4,
            "top": 16,
            "bottom": 16,
            "position": YGPositionType.absolute,
        ]
    }
    
    private class DottedLineDiagramComponent: ViewComponent {
        private var lineWidth: CGFloat = 6
        private var pattern: [CGFloat] = [0, 12]
        private var dashPhase: CGFloat = 6
        private var color: UIColor = getUIColorFromHexadecimal(hex: "808080")
        
        override func render() -> NodeType {
            return Node<DottedLineDiagramView>() { view, layout, _ in
                self.applyStyles(view: view, layout: layout)
                self.applyDottedLineDiagramStyles(view: view, layout: layout)
                view.createDottedLineShapeLayer(color: self.color, lineWidth: self.lineWidth, pattern: self.pattern, dashPhase: self.dashPhase)
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
