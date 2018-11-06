//
//  MasabiTicketManagement.swift
//  NavitiaSDKPartners
//
//  Created by Valentin COUSIEN on 09/05/2018.
//  Copyright © 2018 Kisio. All rights reserved.
//

import Foundation
import UIKit
import JustRideSDK

@objc(MasabiTicketManagement) public class MasabiTicketManagement : NSObject, TicketManagement {

    internal struct DetailMJRError {
        var code : Int
        var details : [String : Any]
    }
    
    
    internal var privateHasValidTickets : Bool = false
    
    public func getTicketManagementName() -> String {
        return "Masabi"
    }
    
    public func getTicketManagementType() -> TicketManagementType {
        return .Masabi
    }
    
    public var ticketConfiguration: TicketManagementConfiguration?
    
    public var hasValidTickets: Bool {
        get {
            return privateHasValidTickets
        }
    }
    
    private let defaultImage : String = "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" // 🤢 
    
    private func authenticate(force : Bool, doRefreshIfInternalError : Bool = true, callbackSuccess : @escaping () -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void) {
        
        if Reachability.isConnectedToNetwork() == false {
            print("NavitiaSDKPartners : no internet connection")
            let error = NavitiaSDKPartnersReturnCode.notConnected
            callbackError(error.getCode(), error.getError())
            return
        }
        
        
        (self.ticketConfiguration as! MasabiTicketManagementConfiguration).MasabiSharedInstance.accountUseCases.accountLogout(completionHandler: { (error) in
        NavitiaSDKPartners.shared.refreshToken(callbackSuccess: {
            (self.ticketConfiguration as! MasabiTicketManagementConfiguration).MasabiSharedInstance.accountUseCases.getLoginStatus(completionHandler: { (loginStatus, error) in
            
            var loginStatusError : DetailMJRError = DetailMJRError(code: 0, details: [:])
            if error != nil {
                print("NavitiaSDKPartners/getLoginStatus : error")
                loginStatusError = self.handleMasabiError(error: error!)
            }
                
            if error == nil && loginStatus?.isLoggedIn == false {
                (self.ticketConfiguration as! MasabiTicketManagementConfiguration).MasabiSharedInstance.accountUseCases.accountLogin(withDeviceChange: force, username: NavitiaSDKPartners.shared.userInfo.id, password: NavitiaSDKPartners.shared.accessToken, completionHandler: { (loginResponse, error) in
                    DispatchQueue.main.async {
                        if (error != nil) {
                            print("NavitiaSDKPartners/masabiAuthenticate : error")
                            self.MasabiLogOut(callbackSuccess: {
                                
                            }, callbackError: { (_, _) in
                                
                            })
                            let accountLoginError = self.handleMasabiError(error: error!)
                            callbackError(accountLoginError.code, accountLoginError.details)
                            return;
                        }
                        
                        switch (loginResponse!.loginResult) {
                        case MJRLoginResult.success:
                            callbackSuccess()
                            break;
                        case MJRLoginResult.failedAccountAssignedToAnotherDevice:
                            var error : NavitiaSDKPartnersReturnCode
                            var data : [String: Any]? = [:]
                            if force || loginResponse?.deviceSwitchInformation?.remainingChanges == 0 {
                                error = NavitiaSDKPartnersReturnCode.masabiNoDeviceChangeCredit
                                data = error.getError()
                            } else {
                                error = NavitiaSDKPartnersReturnCode.masabiDeviceChangeError
                                data = error.getError()
                                if loginResponse != nil && loginResponse?.deviceSwitchInformation != nil {
                                    data!["details"] = ["remainingChanges" : loginResponse?.deviceSwitchInformation?.remainingChanges]
                                }
                            }
                            
                            print("NavitiaSDKPartners/sync : can't sync")
                            callbackError(error.getCode(), error.getError())
                            break;
                        default:
                            
                            if doRefreshIfInternalError == true {
                                
                                NavitiaSDKPartners.shared.refreshToken(callbackSuccess: {
                                    self.authenticate(force: force, doRefreshIfInternalError: false, callbackSuccess: callbackSuccess, callbackError: callbackError)
                                }, callbackError: { (statusCode, data) in
                                    print("NavitiaSDKPartners/masabiAuthenticate : error")
                                    
                                    self.MasabiLogOut(callbackSuccess: {
                                        
                                    }, callbackError: { (_, _) in
                                        
                                    })
                                    callbackError( NavitiaSDKPartnersReturnCode.invalidGrant.getCode(),
                                                   NavitiaSDKPartnersReturnCode.invalidGrant.getError() )
                                })
                            } else {
                                
                                print("NavitiaSDKPartners/masabiAuthenticate : error")
                                self.MasabiLogOut(callbackSuccess: {
                                    
                                }, callbackError: { (_, _) in
                                    
                                })
                                callbackError(  NavitiaSDKPartnersReturnCode.internalServerError.getCode(),
                                                NavitiaSDKPartnersReturnCode.internalServerError.getError() )
                            }
                            break
                        }
                    }
                })
            } else if error == nil && loginStatus?.isLoggedIn == true {
                print("NavitiaSDKPartners/getLoginStatus : success")
                DispatchQueue.main.async {
                   
                    callbackSuccess()
                }
            } else {
                print("NavitiaSDKPartners/getLoginStatus : error")
                DispatchQueue.main.async {
                    if doRefreshIfInternalError == true {
                        NavitiaSDKPartners.shared.refreshToken(callbackSuccess: {
                            self.authenticate(force: force, doRefreshIfInternalError: false, callbackSuccess: callbackSuccess, callbackError: callbackError)
                        }, callbackError: { (statusCode, data) in
                            self.MasabiLogOut(callbackSuccess: {
                                
                            }, callbackError: { (_, _) in
                                
                            })
                            callbackError(  NavitiaSDKPartnersReturnCode.invalidGrant.getCode(),
                                            NavitiaSDKPartnersReturnCode.invalidGrant.getError() )
                        })
                    } else {
                        
                        self.MasabiLogOut(callbackSuccess: {
                            
                        }, callbackError: { (_, _) in
                            
                        })
                        
                        callbackError( loginStatusError.code, loginStatusError.details )
                    }
                }
            }
            }) }, callbackError: {(statusCode, data) in
                
                callbackError(statusCode, data)
        })
        })
    }
    
    private func syncWallet( completion : @escaping (Bool, Int, [String: Any]?) -> Void) {
        (self.ticketConfiguration as! MasabiTicketManagementConfiguration).MasabiSharedInstance.walletUseCases.syncWallet(completionHandler: { (walletStatus, error) in
            if error == nil {
                
                DispatchQueue.main.async {
                   completion(true, 200, nil)
                }
            } else {
                
                DispatchQueue.main.async {
                    let detailedError = self.handleMasabiError(error: error!)
                    completion(false, detailedError.code, detailedError.details)
                }
            }
        })
    }
    
    public func MasabiLogOut(callbackSuccess : @escaping () -> Void,
                             callbackError : @escaping (Int, [String: Any]?) -> Void) {
        
        if Reachability.isConnectedToNetwork() == false {
            print("NavitiaSDKPartners : no internet connection")
            let error = NavitiaSDKPartnersReturnCode.notConnected
            callbackError(error.getCode(), error.getError())
            return
        }
        (self.ticketConfiguration as! MasabiTicketManagementConfiguration).MasabiSharedInstance.accountUseCases.accountLogout(completionHandler: { (error) in
            if error == nil {
                callbackSuccess()
                return
            }
            let retValue = NavitiaSDKPartnersReturnCode.internalError
            callbackError(retValue.getCode(), retValue.getError())
        })
    }
    
    public func syncWalletWithErrorOnDeviceChange( callbackSuccess : @escaping () -> Void,
                                                   callbackError : @escaping (Int, [String: Any]?) -> Void) {
        
        if Reachability.isConnectedToNetwork() == false {
            print("NavitiaSDKPartners : no internet connection")
            let error = NavitiaSDKPartnersReturnCode.notConnected
            callbackError(error.getCode(), error.getError())
            return
        }
        setHasValidTickets()
        if NavitiaSDKPartners.shared.isConnected {
            authenticate(force : false, callbackSuccess: { () in
                self.syncWallet(completion: { (success, statusCode, data) in
                    if success {
                        print("NavitiaSDKPartners/syncWallet : success")
                        
                        callbackSuccess()
                    } else {
                        print("NavitiaSDKPartners/syncWallet : error")
                        
                        self.MasabiLogOut(callbackSuccess: {
                            
                        }, callbackError: { (_, _) in
                            
                        })
                        callbackError(statusCode, data)
                    }
                })
            }, callbackError: { (statusCode, data) in
                
                callbackError(statusCode, data)
            })
        } else {
            NavitiaSDKPartners.shared.createAccount(callbackSuccess: {
                self.authenticate(force : false, callbackSuccess: { () in
                    self.syncWallet(completion: { (success, statusCode, data) in
                        if success {
                            print("NavitiaSDKPartners/syncWallet : success")
                            
                            callbackSuccess()
                        } else {
                            print("NavitiaSDKPartners/syncWallet : error")
                            
                            self.MasabiLogOut(callbackSuccess: {
                                
                            }, callbackError: { (_, _) in
                                
                            })
                            callbackError( statusCode, data)
                        }
                    })
                }, callbackError: { (statusCode, data) in
                    
                    if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                        
                        callbackError(statusCode, (data == nil ? NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError() : data) )
                    } else {
                        
                        callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                    }
                })
            }, callbackError: { (statusCode, data) in
                if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                    
                    callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {
                    
                    callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                }
            })
        }
    }
    
    public func syncWallet( callbackSuccess : @escaping () -> Void,
                           callbackError : @escaping (Int, [String: Any]?) -> Void) {
        
        if Reachability.isConnectedToNetwork() == false {
            print("NavitiaSDKPartners : no internet connection")
            let error = NavitiaSDKPartnersReturnCode.notConnected
            callbackError(error.getCode(), error.getError())
            return
        }
        setHasValidTickets()
        if NavitiaSDKPartners.shared.isConnected {
            authenticate(force: true, callbackSuccess: { () in
                                self.syncWallet(completion: { (success, statusCode, data) in
                                    if success {
                                        print("NavitiaSDKPartners/syncWallet : success")
                                        
                                        callbackSuccess()
                                    } else {
                                        print("NavitiaSDKPartners/syncWallet : error")
                                        
                                        self.MasabiLogOut(callbackSuccess: {
                                            
                                        }, callbackError: { (_, _) in
                                            
                                        })
                                        callbackError(statusCode, data)
                                    }
                                })
            }, callbackError: { (statusCode, data) in
                
                callbackError(statusCode, data)
            })
        } else {
            NavitiaSDKPartners.shared.createAccount(callbackSuccess: {
                self.authenticate(force: true, callbackSuccess: { () in
                    self.syncWallet(completion: { (success, statusCode, data) in
                        if success {
                            print("NavitiaSDKPartners/syncWallet : success")
                            
                            callbackSuccess()
                        } else {
                            print("NavitiaSDKPartners/syncWallet : error")
                            
                            self.MasabiLogOut(callbackSuccess: {
                                
                            }, callbackError: { (_, _) in
                                
                            })
                            callbackError(statusCode, data)
                        }
                    })
                }, callbackError: { (statusCode, data) in
                    if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                        
                        callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                    } else {
                        
                        callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                    }
                })
            }, callbackError: { (statusCode, data) in
                if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {
                    
                    callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {
                    
                    callbackError(NavitiaSDKPartnersReturnCode.internalServerError.getCode(), NavitiaSDKPartnersReturnCode.internalServerError.getError())
                }
            })
        }
    }
    
    public func showWallet( callbackSuccess : @escaping (UIViewController) -> Void,
                            callbackError : @escaping (Int, [String: Any]?) -> Void ) {
        
        setHasValidTickets()
        print("NavitiaSDKPartners/showWallet : success")
        callbackSuccess(MJRWalletViewController.init(justrideSDK: (self.ticketConfiguration as! MasabiTicketManagementConfiguration).MasabiSharedInstance))
    }
    
    public func configuration(data : Data, pictureHeight : CGFloat, picture : String = "", mainColor : UIColor, contrastColor : UIColor) {
        var picture = picture
        if picture.isEmpty {
            picture = defaultImage
        }
        
        let masabiTicketManagementConfiguration = MasabiTicketManagementConfiguration(data: data)
        masabiTicketManagementConfiguration.UIConfiguration?.ticket.ticketButtonBackgroundColour = mainColor
        masabiTicketManagementConfiguration.UIConfiguration?.ticket.ticketButtonTextColour = contrastColor
        masabiTicketManagementConfiguration.UIConfiguration?.ticket.activationDisclaimerBackgroundColour = mainColor
        masabiTicketManagementConfiguration.UIConfiguration?.ticket.activationDisclaimerTextColour = contrastColor
        masabiTicketManagementConfiguration.UIConfiguration?.ticket.activationDisclaimerAcceptButtonTextColour = mainColor
        masabiTicketManagementConfiguration.UIConfiguration?.ticket.activateButtonBackgroundColour = mainColor
        masabiTicketManagementConfiguration.UIConfiguration?.ticket.activateButtonTextColour = contrastColor
        masabiTicketManagementConfiguration.UIConfiguration?.ticket.multiRiderBarBackgroundColour = mainColor
        masabiTicketManagementConfiguration.UIConfiguration?.ticket.ticketConfigurableContent = MJRTicketConfigurableContent(html: """
            <html style="height: 100%;">
            <body style="margin: 0; padding: 0; height: 100%">
            <div style="height: 100%;
            background-position: center center;
            background-repeat: no-repeat;
            background-size: contain;
            background-image:  url('data:image/jpeg;base64,\(picture)');">
            </div>
            </body>
            </html>
            """,
            baseURL: Bundle.main.bundleURL,
            height: pictureHeight)
        masabiTicketManagementConfiguration.UIConfiguration?.ticketInfo.inactiveTabBackgroundColour = mainColor
        masabiTicketManagementConfiguration.UIConfiguration?.wallet.backgroundColour = mainColor
        masabiTicketManagementConfiguration.UIConfiguration?.wallet.ticketCornerRadius = 5
    }
    
    private func handleMasabiError(error : MJRError) -> DetailMJRError {
        
        var detailedError : DetailMJRError = DetailMJRError(code: 0, details: [ : ])
        
        switch error.code {
        case 102:
            detailedError.code = NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getCode()
            detailedError.details = NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getError()
            detailedError.details["details"] = "Another user already logged in"
            detailedError.details["code"] = error.code
            detailedError.details["domain"] = "Login Error"
        case 103:
            detailedError.code = NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getCode()
            detailedError.details = NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getError()
            detailedError.details["details"] = "Account assigned to another device"
            detailedError.details["code"] = error.code
            detailedError.details["domain"] = "Login Error"
        case 105:
            detailedError.code = NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getCode()
            detailedError.details = NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getError()
            detailedError.details["details"] = "Username or password is invalid"
            detailedError.details["code"] = error.code
            detailedError.details["domain"] = "Login Error"
        case 106:
            detailedError.code = NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getCode()
            detailedError.details = NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getError()
            detailedError.details["details"] = "User Blocked"
            detailedError.details["code"] = error.code
            detailedError.details["domain"] = "Login Error"
        case 200:
            if error.domain == "account.login" {
                
                detailedError.code = NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getCode()
                detailedError.details = NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getError()
                detailedError.details["domain"] = "Login Error"
            } else {
                
                detailedError.code = NavitiaSDKPartnersReturnCode.masabiNetworkError.getCode()
                detailedError.details = NavitiaSDKPartnersReturnCode.masabiNetworkError.getError()
                detailedError.details["domain"] = "Network Error"
            }
            detailedError.details["details"] = "Underlying network error"
            detailedError.details["code"] = error.code
            detailedError.details["underlying"] = error.recursiveErrorDescription
        case 401:
            detailedError.code = NavitiaSDKPartnersReturnCode.masabiNetworkError.getCode()
            detailedError.details = NavitiaSDKPartnersReturnCode.masabiNetworkError.getError()
            detailedError.details["details"] = "Authentication Failure"
            detailedError.details["code"] = error.code
            detailedError.details["domain"] = "Network Error"
        case 755:
            detailedError.code = NavitiaSDKPartnersReturnCode.masabiNetworkError.getCode()
            detailedError.details = NavitiaSDKPartnersReturnCode.masabiNetworkError.getError()
            detailedError.details["details"] = "HTTP certificate validation failure"
            detailedError.details["code"] = error.code
            detailedError.details["domain"] = "Network Error"
        case 900:
            if error.domain == "account.login" {
            
                detailedError.code = NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getCode()
                detailedError.details = NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getError()
                detailedError.details["domain"] = "Login Error"
            } else {
            
                detailedError.code = NavitiaSDKPartnersReturnCode.masabiNetworkError.getCode()
                detailedError.details = NavitiaSDKPartnersReturnCode.masabiNetworkError.getError()
                detailedError.details["domain"] = "Network Error"
            }
            detailedError.details["details"] = "Underlying network error"
            detailedError.details["underlying"] = error.recursiveErrorDescription
            detailedError.details["code"] = error.code
        default:
            detailedError.code = NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getCode()
            detailedError.details = NavitiaSDKPartnersReturnCode.masabiAuthenticateError.getError()
            detailedError.details["details"] = error.errorDescription
            detailedError.details["code"] = error.code
            detailedError.details["domain"] = "Login Error"
        }
        
        return detailedError
    }
}

extension MasabiTicketManagement {
    func setHasValidTickets() {
        (self.ticketConfiguration as! MasabiTicketManagementConfiguration).MasabiSharedInstance.walletUseCases.getAvailableTickets(with: MJRAvailableTicketsSortOrder.recentlyPurchased, completionHandler: { (summary, error) in
            if error != nil {
                self.privateHasValidTickets = false
            }
            self.privateHasValidTickets = ( (summary?.count ?? 0) > 0 ? true : false )
        })
    }
}
