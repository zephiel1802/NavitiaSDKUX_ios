import Foundation

open class NavitiaConfiguration: NSObject {
    open let token:String

    public init(token: String) {
        self.token = token
    }
}