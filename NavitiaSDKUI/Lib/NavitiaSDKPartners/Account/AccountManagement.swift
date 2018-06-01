//
//  AccountManagement.swift
//
//  Created by Valentin COUSIEN on 07/03/2018.
//  Copyright © 2018 Valentin COUSIEN. All rights reserved.
//

import Foundation

@objc(AccountManagement) public protocol AccountManagement {
    
    func getAccountManagementName() -> String
    func getAccountManagementType() -> AccountManagementType
    
    var accountConfiguration : AccountManagementConfiguration? { get set }
    var accessToken : String { get }
    var userInfo : NavitiaUserInfo { get }
    var isConnected : Bool { get }
    var isAnonymous : Bool { get }
    
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
    
    func transformAccount(  firstName : String, lastName : String, email : String, birthdate : Date?, password : String, courtesy : NavitiaSDKPartnersCourtesy,
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
