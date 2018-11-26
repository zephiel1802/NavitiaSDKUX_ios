import Foundation

open class NavitiaSDK: NSObject {
    public let journeysApi: JourneysApi
    public let poisApi: PoisApi

    public init(configuration:NavitiaConfiguration) {
        self.journeysApi = JourneysApi(token: configuration.token)
        self.poisApi = PoisApi(token: configuration.token)
    }
}
