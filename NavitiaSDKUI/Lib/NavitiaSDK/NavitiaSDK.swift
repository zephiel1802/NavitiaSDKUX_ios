import Foundation

open class NavitiaSDK: NSObject {
    open let journeysApi: JourneysApi
    open let poisApi: PoisApi

    public init(configuration:NavitiaConfiguration) {
        self.journeysApi = JourneysApi(token: configuration.token)
        self.poisApi = PoisApi(token: configuration.token)
    }
}
