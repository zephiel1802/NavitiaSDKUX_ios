import Render
import UIKit
import NavitiaSDK

open class JourneySolutionRoadBookController: ViewController, ComponentController {
    var journey: Journey?

    public var component: JourneySolutionRoadBookScreen = JourneySolutionRoadBookScreen()

    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addComponentToViewControllerHierarchy()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override open func viewDidLayoutSubviews() {
        renderComponent(options: [.preventViewHierarchyDiff])
    }

    public func configureComponentProps() {
        component.state.journey = self.journey
    }
}
    
