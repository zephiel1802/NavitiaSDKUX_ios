//
//  AccountManagement.swift
//
//  Created by Valentin COUSIEN on 07/03/2018.
//  Copyright © 2018 Valentin COUSIEN. All rights reserved.
//

import Foundation

@objc(AccountManagement) public protocol AccountManagement {
    
    var configuration : AccountManagementConfiguration? { get set }
    
    var userInfo : NavitiaUserInfo { get }
    
    var isConnected : Bool { get }
    
    var isAnonymous : Bool { get }
    
    func getAccountManagementName() -> String
    
    func getAccountManagementType() -> AccountManagementType
    
    func authenticate( username : String, password : String,
                       callbackSuccess : @escaping () -> Void,
                       callbackError : @escaping (Int, [String: Any]?) -> Void)
 
    func logOut( callbackSuccess : @escaping () -> Void,
                 callbackError : @escaping (Int, [String: Any]?) -> Void)
 
    func createAccount( callbackSuccess : @escaping () -> Void,
                        callbackError : @escaping (Int, [String: Any]?) -> Void)
    
    func createAccount(  firstName : String, lastName : String, email : String, birthdate : Date?, password : String, courtesy : NavitiaSDKPartnersCourtesy,
                         callbackSuccess: @escaping () -> Void,
                         callbackError: @escaping (Int, [String: Any]?) -> Void)
    
    func activateAccount( internetAccountId : String, token : String,
                          callbackSuccess: @escaping () -> Void,
                          callbackError: @escaping (Int, [String: Any]?) -> Void)
    
    func resetPassword( email : String,
                        callbackSuccess : @escaping () -> Void,
                        callbackError : @escaping (Int, [String: Any]?) -> Void)
    
    func updatePassword( oldPassword : String, newPassword : String,
                         callbackSuccess : @escaping () -> Void,
                         callbackError : @escaping (Int, [String: Any]?) -> Void)
    
    func getUserInfo(  callbackSuccess : @escaping (NavitiaUserInfo) -> Void,
                       callbackError : @escaping (Int, [String: Any]?) -> Void)
    
    func transformAccount( firstName : String, lastName : String, email : String, birthdate : Date?, password : String, courtesy : NavitiaSDKPartnersCourtesy,
                            callbackSuccess: @escaping () -> Void,
                            callbackError: @escaping (Int, [String: Any]?) -> Void)
    
    func updateInfo( firstName : String, lastName : String, email : String, birthdate : Date?, courtesy : NavitiaSDKPartnersCourtesy,
                     callbackSuccess: @escaping () -> Void,
                     callbackError: @escaping (Int, [String: Any]?) -> Void)
    
    func sendActivationEmail( callbackSuccess: @escaping () -> Void,
                              callbackError: @escaping (Int, [String: Any]?) -> Void)
    
    
    func refreshToken( callbackSuccess: @escaping () -> Void,
                       callbackError: @escaping (Int, [String: Any]?) -> Void)
}

extension AccountManagement {
    
    func updateInfo( firstName : String = "", lastName : String = "", email : String = "", birthdate : Date? = nil, courtesy : NavitiaSDKPartnersCourtesy = .Unknown,
                     callbackSuccess: @escaping () -> Void,
                     callbackError: @escaping (Int, [String: Any]?) -> Void) {
        
        updateInfo(firstName: firstName, lastName: lastName, email: email, birthdate: birthdate, courtesy: courtesy, callbackSuccess: callbackSuccess, callbackError: callbackError)
        
    }
    
}



