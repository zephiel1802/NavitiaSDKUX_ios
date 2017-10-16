import Foundation
import Render
import NavitiaSDK

extension Components.Journey.Roadmap.Sections.PublicTransport.Details {
    class IntermediateStopPointComponent: ViewComponent {
        let SectionRowLayoutComponent = Components.Journey.Roadmap.Sections.SectionRowLayoutComponent.self
        let StopPointIconComponent = Components.Journey.Roadmap.Sections.LineDiagram.StopPointIconComponent.self
        
        var stopDateTime: StopDateTime?
        var color: UIColor?

        override func render() -> NodeType {
            return ComponentNode(self.SectionRowLayoutComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.SectionRowLayoutComponent, _) in
                component.styles = self.styles

                component.secondComponent = ComponentNode(self.StopPointIconComponent.init(), in: self, props: { (component: Components.Journey.Roadmap.Sections.LineDiagram.StopPointIconComponent, _) in
                    component.color = self.color!
                    component.outerFontSize = 12
                    component.innerFontSize = 0
                })
                
                component.thirdComponent = ComponentNode(ViewComponent(), in: self, props: { (component: ViewComponent, hasKey: Bool) in
                    component.styles = self.containerStyle
                }).add(children: [
                    ComponentNode(LabelComponent(), in: self, props: { (component: LabelComponent, hasKey: Bool) in
                        component.styles = self.stopPointLabelStyle
                        component.text = self.stopDateTime!.stopPoint!.label!
                    })
                ])
            })
        }

        let containerStyle: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
            "paddingHorizontal": 5,
            "paddingTop": 2,
            "paddingBottom": 0,
        ]
        let stopPointLabelStyle: [String: Any] = [
            "color": UIColor.darkText,
            "fontWeight": "bold",
            "fontSize": 12,
            "marginRight": 5,
        ]
    }
}
