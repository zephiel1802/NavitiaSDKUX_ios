import Foundation

extension Components.Journey.Roadmap.Steps {
    class JourneyRoadmap2ColumnsLayout: ViewComponent {
        var leftChildren: [NodeType]?
        var rightChildren: [NodeType]?
        
        override func render() -> NodeType {
            let computedStyles = mergeDictionaries(dict1: containerStyles, dict2: self.styles)
            let container = ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                component.styles = computedStyles
            })
            
            container.add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                    component.styles = self.leftComponentStyles
                }).add(children:  self.leftChildren ?? [])
            ])
            
            container.add(children: [
                ComponentNode(ViewComponent(), in: self, props: { (component, _) in
                    component.styles = self.rightComponentStyles
                }).add(children:  self.rightChildren ?? [])
            ])
            
            return container
        }
        
        let leftComponentStyles: [String: Any] = [
            "width": 50,
        ]
        let rightComponentStyles: [String: Any] = [
            "flexGrow": 1,
            "flexShrink": 1,
        ]
        let containerStyles: [String: Any] = [
            "flexDirection": YGFlexDirection.row,
        ]
    }
}
