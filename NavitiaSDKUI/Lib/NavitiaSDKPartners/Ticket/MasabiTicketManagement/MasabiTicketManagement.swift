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
    
    private func authenticate(force : Bool, doRefreshIfInternalError : Bool = true, callbackSuccess : @escaping () -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void) {
        
        if Reachability.isConnectedToNetwork() == false {
            print("NavitiaSDKPartners : no internet connection")
            let error = NavitiaSDKPartnersReturnCode.notConnected
            callbackError(error.getCode(), error.getError())
            return
        }
        MJRSDK.sharedInstance()?.accountUseCases.getLoginStatus(completionHandler: { (loginStatus, error) in
            
            if error != nil {
                print("NavitiaSDKPartners/getLoginStatus : success")
            }
            
            if error == nil && loginStatus?.isLoggedIn == false {
                print(NavitiaSDKPartners.shared.userInfo.id)
                print(NavitiaSDKPartners.shared.accessToken)
                MJRSDK.sharedInstance()?.accountUseCases.accountLogin(withDeviceChange: force, username: NavitiaSDKPartners.shared.userInfo.id, password: NavitiaSDKPartners.shared.accessToken, completionHandler: { (loginResponse, error) in
                    DispatchQueue.main.async {
                        if (error != nil) {
                            print("NavitiaSDKPartners/masabiAuthenticate : error")
                            callbackError(NavitiaSDKPartnersReturnCode.internalError.getCode(), NavitiaSDKPartnersReturnCode.internalError.getError())
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
                            
                            print("NavitiaSDKPartners/masabiAuthenticate : error")
                            callbackError( error.getCode(),
                                           data)
                            break;
                        default:
                            if doRefreshIfInternalError == true {
                                NavitiaSDKPartners.shared.refreshToken(callbackSuccess: {
                                    self.authenticate(force: force, doRefreshIfInternalError: false, callbackSuccess: callbackSuccess, callbackError: callbackError)
                                }, callbackError: { (statusCode, data) in
                                    
                                    print(loginResponse!.loginResult.rawValue)
                                    print("NavitiaSDKPartners/masabiAuthenticate : error")
                                    callbackError(NavitiaSDKPartnersReturnCode.internalError.getCode(), NavitiaSDKPartnersReturnCode.internalError.getError())
                                    
                                })
                            } else {
                                
                                print("NavitiaSDKPartners/masabiAuthenticate : error")
                                print(loginResponse!.loginResult.rawValue)
                                callbackError(NavitiaSDKPartnersReturnCode.internalError.getCode(), NavitiaSDKPartnersReturnCode.internalError.getError())
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
                            callbackError(NavitiaSDKPartnersReturnCode.internalError.getCode(), NavitiaSDKPartnersReturnCode.internalError.getError())
                            
                        })
                    } else {
                        callbackError(NavitiaSDKPartnersReturnCode.internalError.getCode(), NavitiaSDKPartnersReturnCode.internalError.getError())
                    }
                }
            }
        })
    }
    
    private func syncWallet( completion : @escaping (Bool, Int, [String: Any]?) -> Void) {
        MJRSDK.sharedInstance()?.walletUseCases.syncWallet(completionHandler: { (walletStatus, error) in
            if error == nil {
                DispatchQueue.main.async {
                   completion(true, 200, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, (error?.code) ?? 0, [ "error" : error?.description ?? "" ])
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
        MJRSDK.sharedInstance()?.accountUseCases.accountLogout(completionHandler: { (error) in
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
                            callbackError(statusCode, data)
                        }
                    })
                }, callbackError: { (statusCode, data) in
                    callbackError(statusCode, data)
                })
            }, callbackError: { (statusCode, data) in
                callbackError(statusCode, data)
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
                            
                            print("NavitiaSDKPartners/syncWallet : false")
                            callbackError(statusCode, data)
                        }
                    })
                }, callbackError: { (statusCode, data) in
                    callbackError(statusCode, data)
                })
            }, callbackError: { (statusCode, data) in
                callbackError(statusCode, data)
            })
        }
    }
    
    public func showWallet( callbackSuccess : @escaping (UIViewController) -> Void,
                            callbackError : @escaping (Int, [String: Any]?) -> Void ) {
        
        setHasValidTickets()
        print("NavitiaSDKPartners/showWallet : success")
        callbackSuccess(MJRWalletViewController())
    }
    
}

extension MasabiTicketManagement {
    private func setHasValidTickets() {
        MJRSDK.sharedInstance()?.walletUseCases.getAvailableTickets(with: MJRAvailableTicketsSortOrder.recentlyPurchased, completionHandler: { (summary, error) in
            if error != nil {
                self.privateHasValidTickets = false
            }
            print((summary?.count ?? 0))
            self.privateHasValidTickets = ( (summary?.count ?? 0) > 0 ? true : false )
        })
    }
}
