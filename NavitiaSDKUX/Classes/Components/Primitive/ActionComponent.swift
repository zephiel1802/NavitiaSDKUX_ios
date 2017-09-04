import Foundation
import Render

class ActionComponent: ComponentView<NilState> {
    var onTap:((UIGestureRecognizer)->Void)?

    override func render() -> NodeType {
        return Node<UIView>() { view, layout, size in
            view.onTap(self.onTap!)
        }
    }
}