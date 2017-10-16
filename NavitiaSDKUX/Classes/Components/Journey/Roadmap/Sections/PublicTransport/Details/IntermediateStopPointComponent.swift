import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.PublicTransport.Details {
    class IntermediateStopPointComponent: ViewComponent {
        let SectionLayoutComponent = Components.Journey.Roadmap.Sections.SectionLayoutComponent.self
        
        var stopDateTime: StopDateTime?
        var color: UIColor?

        override func render() -> NodeType {
            return ComponentNode(SectionLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionLayoutComponent, hasKey: Bool) in
                component.styles = self.styles

                component.header = ComponentNode(ViewComponent(), in: self)

                /*
                component.body = ComponentNode(LineDiagramForIntermediateStopPointComponent(), in: self, props: { (component: LineDiagramForIntermediateStopPointComponent, hasKey: Bool) in
                    component.color = self.color
                })
                */

                component.footer = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.intermediateStopPointLabelContainerStyle
                }).add(children: [
                    ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                        component.styles = self.intermediateStopPointLabelStyle

                        component.text = self.stopDateTime!.stopPoint!.label!
                    })
                ])
            })
        }

        let intermediateStopPointLabelContainerStyle: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
            "backgroundColor": UIColor.white,
            "paddingHorizontal": 5,
            "paddingTop": 2,
            "paddingBottom": 0,
        ]
        let intermediateStopPointLabelStyle: [String: Any] = [
            "color": UIColor.darkText,
            "fontWeight": "bold",
            "fontSize": 12,
            "marginRight": 5,
        ]
    }
}
