//
//  AccountMonCompte.swift
//
//  Created by Valentin COUSIEN on 07/03/2018.
//  Copyright © 2018 Valentin COUSIEN. All rights reserved.
//

import Foundation

@objc(KeolisAccountManagement) public class KeolisAccountManagement : NSObject, AccountManagement {

    internal var _accessToken : String {
        get {
            return UserDefaults.standard.string(forKey: "__NavitiaSDKPartners_KeolisAccountManagement_accessToken") ?? ""
        }

        set {
            UserDefaults.standard.set(newValue, forKey: "__NavitiaSDKPartners_KeolisAccountManagement_accessToken")
        }
    }

    internal var _refreshToken : String {
        get {
            return UserDefaults.standard.string(forKey: "__NavitiaSDKPartners_KeolisAccountManagement_refreshToken") ?? ""
        }

        set {
            UserDefaults.standard.set(newValue, forKey: "__NavitiaSDKPartners_KeolisAccountManagement_refreshToken")
        }
    }

    internal var _anonymousEmail : String {
        get {
            return UserDefaults.standard.string(forKey: "__NavitiaSDKPartners_KeolisAccountManagement_anonymousEmail") ?? ""
        }

        set {
            UserDefaults.standard.set(newValue, forKey: "__NavitiaSDKPartners_KeolisAccountManagement_anonymousEmail")
        }
    }

    internal var _anonymousPassword : String {
        get {
            return UserDefaults.standard.string(forKey: "__NavitiaSDKPartners_KeolisAccountManagement_anonymousPassword") ?? ""
        }

        set {
            UserDefaults.standard.set(newValue, forKey: "__NavitiaSDKPartners_KeolisAccountManagement_anonymousPassword")
        }
    }

    public var isConnected: Bool {
        get {
            return !(_accessToken.isEmpty)
        }
    }

    public var isAnonymous: Bool {
        get {
            if !isConnected {
                return false
            }
            return (self.userInfo as! KeolisUserInfo).accountStatus == .anonymous
        }
    }

    internal var _keolisConfiguration : KeolisAccountManagementConfiguration? = nil

    public private(set) var userInfo : NavitiaUserInfo {
        get {
            let decoded = UserDefaults.standard.object(forKey: "__NavitiaSDKPartners_KeolisAccountManagement_userInfo") as? Data
            if decoded == nil {
                return KeolisUserInfo()
            }
            return NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! KeolisUserInfo
        }

        set {
            let encodedData : Data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(encodedData, forKey: "__NavitiaSDKPartners_KeolisAccountManagement_userInfo")
            UserDefaults.standard.synchronize()
        }
    }

    public var configuration : AccountManagementConfiguration? {
        get {
            return _keolisConfiguration
        }

        set {
            _keolisConfiguration = (newValue as! KeolisAccountManagementConfiguration)
        }
    }

    internal func getUserInfo(tryAccess : Bool = true, completion : @escaping (Bool, Int, [String : Any]?) -> Void) {

        NavitiaSDKPartnersRequestBuilder.get(stringUrl: "\((configuration as! KeolisAccountManagementConfiguration).url)/oauth2/\((configuration as! KeolisAccountManagementConfiguration).network)/userinfo", header: _getKeolisConnectedHeader()) { (success, statusCode, data) in

            if (statusCode == 401 || statusCode == 500) && tryAccess == true { // getUserInfo crashing due to disconnection
                self.refreshToken() { success, statusCode, data in // try to refresh
                    if success == true {

                        self.getUserInfo(tryAccess: false) { success, statusCode, data in // if refresh succeed -> retry getUserInfo
                            completion(success, statusCode, data)
                            return
                        }
                    } else {

                        completion(false, NavitiaSDKPartnersReturnCode.notLogged.rawValue, nil)
                        return
                    }
                }
            } else {

                completion(success, statusCode, data)
            }
            return
        }
    }

    internal func updatePassword(oldPassword : String, newPassword: String, tryAccess : Bool = true, completion : @escaping (Bool, Int, [String: Any]?) -> Void) {

        if oldPassword.isEmpty || newPassword.isEmpty {
            var details : [String: Any] = [ : ]
            var data = NavitiaSDKPartnersReturnCode.badParameter.getError()
            if oldPassword.isEmpty {
                details["oldPassword"] = NavitiaSDKPartnersParameterCode.empty
            }
            if newPassword.isEmpty {
                details["newPassword"] = NavitiaSDKPartnersParameterCode.empty
            }
            data["details"] = details
            completion(false, NavitiaSDKPartnersReturnCode.badParameter.getCode(), data)
        }

        NavitiaSDKPartnersRequestBuilder.soapPost(stringUrl: "\((configuration as! KeolisAccountManagementConfiguration).url)/socle/\((configuration as! KeolisAccountManagementConfiguration).network)/UpdateAccount/V1.0/", header: _getKeolisConnectedHeaderWS(), soapMessage: updatePasswordXML(oldPassword: oldPassword, newPassword: newPassword)) { (success, statusCode, data) in

            if statusCode == 401 && tryAccess == true {
                self.refreshToken() { success, statusCode, data in

                    if success == true && statusCode == 200 {

                        self.updatePassword(oldPassword: oldPassword, newPassword: newPassword, tryAccess: false) { success, statusCode, data in
                            completion(success, statusCode, data)
                        }
                    } else {

                        completion(false, NavitiaSDKPartnersReturnCode.notLogged.getCode(), NavitiaSDKPartnersReturnCode.notLogged.getError())
                        return
                    }
                }
            } else {

                if data != nil {

                    completion(success, statusCode, [ "error": (data!["reponse"]["compteRendu"]["libelleRetour"].element?.text) ?? "",
                                                      "code" : (data!["reponse"]["compteRendu"]["codeRetour"].element?.text) ?? "" ] )
                } else if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {

                    completion(success, statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {

                    completion(success, statusCode, nil)
                }
            }
        }
    }

    internal func updateInfo(tryAccess : Bool = true, firstName: String, lastName: String, birthdate: Date?, courtesy: NavitiaSDKPartnersCourtesy, completion : @escaping (Bool, Int, [String : Any]?) -> Void ) {

        if firstName.isEmpty && lastName.isEmpty && firstName.isEmpty && lastName.isEmpty && birthdate == nil && courtesy == .Unknown {
            return
        }

        let courtesyStr : String = (courtesy == .Unknown ? "" : (courtesy == .Mr ? "M." : "MME"))
        NavitiaSDKPartnersRequestBuilder.soapPost(stringUrl: "\((self.configuration as! KeolisAccountManagementConfiguration).url)/socle/\((self.configuration as! KeolisAccountManagementConfiguration).network)/UpdatePerson/V1.0/", header: self._getKeolisConnectedHeaderWS(), soapMessage: updateInfoXML(courtesy: courtesyStr, firstName: firstName, lastName: lastName, birthdate: birthdate), completion: { (success, statusCode, data) in
            if (statusCode == 401) && tryAccess == true {
                self.refreshToken() { success, statusCode, data in
                    if success == true && statusCode == 200 {
                        self.updateInfo(tryAccess: false, firstName: firstName, lastName: lastName, birthdate: birthdate, courtesy: courtesy, completion: { (success, statusCode, data) in
                            completion(success, statusCode, [:])
                        })
                    } else {
                        completion(false, NavitiaSDKPartnersReturnCode.notLogged.getCode(), NavitiaSDKPartnersReturnCode.notLogged.getError())
                    }
                }
            } else {

                if data != nil {

                    completion(success, statusCode, [ "error": (data!["reponse"]["compteRendu"]["libelleRetour"].element?.text) ?? "",
                                                      "code" : (data!["reponse"]["compteRendu"]["codeRetour"].element?.text) ?? "" ] )
                } else if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {

                    completion(success, statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {

                    completion(success, statusCode, nil)
                }
            }
        })
    }

    internal func updateEmail(tryAccess : Bool = true, email : String, completion : @escaping (Bool, Int, [String : Any]?) -> Void ) {

        if !(email.isEmpty) && !(NavitiaSDKPartnersExtension.isValidEmail(str: email)) {
            var data = NavitiaSDKPartnersReturnCode.badParameter.getError()
            var details : [String: Any] = [ : ]
            details["email"] = NavitiaSDKPartnersParameterCode.invalid
            data["details"] = details
            completion(false, NavitiaSDKPartnersReturnCode.badParameter.getCode(), data)
            return
        }

        NavitiaSDKPartnersRequestBuilder.soapPost(stringUrl: "\((configuration as! KeolisAccountManagementConfiguration).url)/socle/\((configuration as! KeolisAccountManagementConfiguration).network)/UpdateAccount/V1.0/", header: _getKeolisConnectedHeaderWS(), soapMessage: updateEmailXML(email: email)) { (success, statusCode, data) in

            if (statusCode == 401) && tryAccess == true {
                self.refreshToken() { success, statusCode, data in
                    if success == true && statusCode == 200 {
                        self.updateEmail(tryAccess: false, email: email) { success, statusCode, data in
                            completion(success, statusCode, data)
                        }
                    } else {
                        completion(false, NavitiaSDKPartnersReturnCode.notLogged.getCode(), NavitiaSDKPartnersReturnCode.notLogged.getError())
                    }
                }
            } else {

                if data != nil {

                    completion(success, statusCode, [ "error": (data!["reponse"]["compteRendu"]["libelleRetour"].element?.text) ?? "",
                                                      "code" : (data!["reponse"]["compteRendu"]["codeRetour"].element?.text) ?? "" ] )
                } else if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {

                    completion(success, statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {

                    completion(success, statusCode, nil)
                }
            }
        }
    }

    internal func refreshToken(completion : @escaping (Bool, Int, [String : Any]?) -> Void) {

        if _refreshToken.isEmpty {
            
            print("NavitiaSDKPartners/refreshToken : error")
            completion(false, NavitiaSDKPartnersReturnCode.notLogged.getCode(), NavitiaSDKPartnersReturnCode.notLogged.getError())
            return
        }

        NavitiaSDKPartnersRequestBuilder.post(stringUrl: "\((configuration as! KeolisAccountManagementConfiguration).url)/oauth2/\((configuration as! KeolisAccountManagementConfiguration).network)/token?grant_type=refresh_token&refresh_token=\(_refreshToken)", header: _getKeolisHeader()) { success, statusCode, data in

            if success == true && statusCode == 200 && data != nil {

                print("NavitiaSDKPartners/refreshToken : success")
                self._accessToken = data!["access_token"] as! String
                completion(success, statusCode, data)
                return
            } else {

                print("NavitiaSDKPartners/refreshToken : error")
                self.authenticate(username: self._anonymousEmail, password: self._anonymousPassword, callbackSuccess: {

                    completion(true, 200, nil)
                }, callbackError: { (statusCode, data) in

                    completion(false, NavitiaSDKPartnersReturnCode.notLogged.getCode(), NavitiaSDKPartnersReturnCode.notLogged.getError())
                    return
                })
            }

        }
    }

    internal func _getKeolisHeader(isXMLContent : Bool = false) -> [String : String] {

        return ["Content-Type" : "application/" + ( isXMLContent ? "xml" : "x-www-form-urlencoded"),
                "Authorization" : "Basic \((configuration as! KeolisAccountManagementConfiguration).encodedSecretClient64Oauth)"]
    }

    internal func _getKeolisConnectedHeader(isXMLContent : Bool = false) -> [String : String] {

        return ["Content-Type" : "application/" + ( isXMLContent ? "xml" : "x-www-form-urlencoded"),
                "Authorization" : "Bearer \(_accessToken)"]
    }

    internal func _getKeolisHeaderWS() -> [String : String] {

        return ["Content-Type" : "application/xml",
                "Authorization" : "Basic \((configuration as! KeolisAccountManagementConfiguration).encodedSecretClient64WS)"]
    }

    internal func _getKeolisConnectedHeaderWS() -> [String: String] {
        return ["Content-Type" : "application/xml",
                "Authorization" : "Bearer \(_accessToken)"]
    }
}

extension KeolisAccountManagement {

    public func getAccountManagementName() -> String {

        return "Keolis"
    }

    public func getAccountManagementType() -> AccountManagementType {

        return .Keolis
    }

    public func authenticate( username: String, password: String,
                              callbackSuccess : @escaping () -> Void, callbackError : @escaping (Int, [String : Any]?) -> Void) {
        if password.isEmpty || username.isEmpty || !(NavitiaSDKPartnersExtension.isValidEmail(str: username)) {

            var data = NavitiaSDKPartnersReturnCode.badParameter.getError()
            var details : [String: Any] = [:]

            if password.isEmpty {
                details["password"] = NavitiaSDKPartnersParameterCode.empty
            }
            if username.isEmpty {
                details["username"] = NavitiaSDKPartnersParameterCode.empty
            } else if !(NavitiaSDKPartnersExtension.isValidEmail(str: username)) {
                details["username"] = NavitiaSDKPartnersParameterCode.invalid
            }
            data["details"] = details
            callbackError(NavitiaSDKPartnersReturnCode.badParameter.getCode(), data)
            return
        }

        let encryptPassword = password.encrypt(key: (_keolisConfiguration!).hmacKey)
        NavitiaSDKPartnersRequestBuilder.post(stringUrl: "\((configuration as! KeolisAccountManagementConfiguration).url)/oauth2/\((configuration as! KeolisAccountManagementConfiguration).network)/token?grant_type=password&password=\((encryptPassword!.encodeURIComponent())!)&username=\((username.encodeURIComponent())!)", header: _getKeolisHeader()) { ( success, statusCode, data) in

            if success && data != nil && statusCode < 300 {

                self._anonymousEmail = username
                self._anonymousPassword = password

                print("NavitiaSDKPartners/authenticate: success")
                self._accessToken = data!["access_token"] as! String
                let refresh : String = (data!["refresh_token"] as? String == nil ? "" : data!["refresh_token"] as! String)
                if !(refresh.isEmpty) {
                    self._refreshToken = refresh
                }

                self.getUserInfo( callbackSuccess: { (userInfo) in
                    callbackSuccess()
                }, callbackError: { (statusCode, data) in
                    callbackError(statusCode, data)
                })
            } else {

                if data != nil && data!["error"] != nil &&
                    statusCode == 400 && (data!["error"] as! String) == "invalid_grant" {
                    print("NavitiaSDKPartners/authenticate: error : \(NavitiaSDKPartnersReturnCode.invalidGrant.getError())")
                    callbackError(NavitiaSDKPartnersReturnCode.invalidGrant.getCode(), NavitiaSDKPartnersReturnCode.invalidGrant.getError())
                    return
                }

                print("NavitiaSDKPartners/authenticate: error : \(data ?? [:])")
                callbackError(statusCode, data)
                return
            }
        }
    }

    public func logOut( callbackSuccess : @escaping () -> Void, callbackError : @escaping (Int, [String : Any]?) -> Void) {

        NavitiaSDKPartnersRequestBuilder.post(stringUrl: "\((configuration as! KeolisAccountManagementConfiguration).url)/oauth2/\((configuration as! KeolisAccountManagementConfiguration).network)/revoke?token=\(_accessToken.encodeURIComponent()!)&token_type_hint=access_token&revoke?token=\(self._refreshToken.encodeURIComponent()!)&token_type_hint=refresh", header: self._getKeolisHeader()) { (success, statusCode, data) in

                if success && statusCode < 300 {

                    print("NavitiaSDKPartners/logOut : success ")
                    self._accessToken = ""
                    self._refreshToken = ""
                    self._anonymousEmail = ""
                    self._anonymousPassword = ""
                    NavitiaSDKPartners.shared.resetCart(callbackSuccess: {
                    }, callbackError: { (_, _) in
                    })
                    callbackSuccess()
                } else {

                    print("NavitiaSDKPartners/logOut : error")
                    callbackError(statusCode, data)
                }
            }
    }

    public func createAccount( callbackSuccess: @escaping () -> Void,
                               callbackError: @escaping (Int, [String : Any]?) -> Void) {

        let password = NavitiaSDKPartnersExtension.randomString(length: 8)
        NavitiaSDKPartnersRequestBuilder.soapPost(stringUrl: "\((configuration as! KeolisAccountManagementConfiguration).url)/socle/\((configuration as! KeolisAccountManagementConfiguration).network)/CreateAccount/V1.0/", header: _getKeolisHeaderWS(), soapMessage: createAccountAnonymousXML(password: password.encrypt(key: (_keolisConfiguration?.hmacKey)!))) { success, statusCode, data in

            if success {

                let email : String = data!["reponse"]["compteRendu"]["compteInternet"]["email"].element?.text ?? ""
                print("NavitiaSDKPartners/createAccount: success")
                self.authenticate(username: email, password: password, callbackSuccess: {

                    callbackSuccess()
                }, callbackError: { (status, data) in

                    callbackError( statusCode, data)
                })
            } else {

                print("NavitiaSDKPartners/createAccount: error")

                if data != nil {

                    callbackError(statusCode, [ "error": (data!["reponse"]["compteRendu"]["libelleRetour"].element?.text) ?? "",
                                                "code" : (data!["reponse"]["compteRendu"]["codeRetour"].element?.text) ?? "" ] )
                } else if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {

                    callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {

                    callbackError(statusCode, nil)
                }
            }
        }
    }

    public func createAccount( firstName : String, lastName : String, email : String, birthdate : Date? = nil, password : String, courtesy: NavitiaSDKPartnersCourtesy = .Unknown,
                               callbackSuccess: @escaping () -> Void,
                               callbackError: @escaping (Int, [String: Any]?) -> Void ) {


        if firstName.isEmpty || lastName.isEmpty || !(NavitiaSDKPartnersExtension.isValidEmail(str: email)) || email.isEmpty || password.isEmpty {
            var data = NavitiaSDKPartnersReturnCode.badParameter.getError()
            var details : [String: Any] = [:]
            if firstName.isEmpty {
                details["firstName"] = NavitiaSDKPartnersParameterCode.empty
            }
            if lastName.isEmpty {
                details["lastName"] = NavitiaSDKPartnersParameterCode.empty
            }
            if password.isEmpty {
                details["password"] = NavitiaSDKPartnersParameterCode.empty
            }
            if email.isEmpty {
                details["email"] = NavitiaSDKPartnersParameterCode.empty
            } else if !(NavitiaSDKPartnersExtension.isValidEmail(str: email)) {
                details["email"] = NavitiaSDKPartnersParameterCode.invalid
            }
            data["details"] = details
            callbackError(NavitiaSDKPartnersReturnCode.badParameter.getCode(), data)
            return
        }

        let courtesyStr : String = (courtesy == .Unknown ? "" : (courtesy == .Mr ? "M." : "MME"))
        NavitiaSDKPartnersRequestBuilder.soapPost(stringUrl: "\((configuration as! KeolisAccountManagementConfiguration).url)/socle/\((configuration as! KeolisAccountManagementConfiguration).network)/CreateAccount/V1.0/", header: _getKeolisHeaderWS(), soapMessage: createAccountNonAnonymousXML(firstName: firstName, lastName: lastName, email: email, birthdate: birthdate, password: (password.encrypt(key: (_keolisConfiguration?.hmacKey)!))!, courtesy: courtesyStr)) { (success, statusCode, data) in

            if success {

                print("NavitiaSDKPartners/createAccount: success")
                callbackSuccess()
            } else {

                print("NavitiaSDKPartners/createAccount: error")

                if data != nil {
                    if ((data!["reponse"]["compteRendu"]["libelleRetour"].element?.text) ?? "") == "Email du compte internet déjà utilisé" {
                        callbackError(NavitiaSDKPartnersReturnCode.infoAlreadyUsed.getCode(), NavitiaSDKPartnersReturnCode.infoAlreadyUsed.getError())
                        return
                    }
                    callbackError(statusCode, [ "error": (data!["reponse"]["compteRendu"]["libelleRetour"].element?.text) ?? "",
                                                "code" : (data!["reponse"]["compteRendu"]["codeRetour"].element?.text) ?? "" ] )
                } else if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {

                    callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {

                    callbackError(statusCode, nil)
                }
            }
        }
    }

    public func transformAccount(firstName: String, lastName: String, email: String, birthdate: Date?, password: String, courtesy : NavitiaSDKPartnersCourtesy, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {

        if firstName.isEmpty || lastName.isEmpty || !(NavitiaSDKPartnersExtension.isValidEmail(str: email)) || email.isEmpty || password.isEmpty {
            var data = NavitiaSDKPartnersReturnCode.badParameter.getError()
            var details : [String: Any] = [:]
            if firstName.isEmpty {
                details["firstName"] = NavitiaSDKPartnersParameterCode.empty
            }
            if lastName.isEmpty {
                details["lastName"] = NavitiaSDKPartnersParameterCode.empty
            }
            if password.isEmpty {
                details["password"] = NavitiaSDKPartnersParameterCode.empty
            }
            if email.isEmpty {
                details["email"] = NavitiaSDKPartnersParameterCode.empty
            } else if !(NavitiaSDKPartnersExtension.isValidEmail(str: email)) {
                details["email"] = NavitiaSDKPartnersParameterCode.invalid
            }
            data["details"] = details
            callbackError(NavitiaSDKPartnersReturnCode.badParameter.getCode(), data)
            return
        }

        let courtesyStr : String = (courtesy == .Unknown ? "" : (courtesy == .Mr ? "M." : "MME"))
        NavitiaSDKPartnersRequestBuilder.soapPost(stringUrl: "\((configuration as! KeolisAccountManagementConfiguration).url)/socle/\((configuration as! KeolisAccountManagementConfiguration).network)/CreateAccount/V1.0/", header: _getKeolisHeaderWS(), soapMessage: transformAccountXML(firstName: firstName, lastName: lastName, email: email, birthdate: birthdate, password: (password.encrypt(key: (_keolisConfiguration?.hmacKey)!))!, courtesy: courtesyStr)) { (success, statusCode, data) in

            if success {

                print("NavitiaSDKPartners/transformAccount: success")
                callbackSuccess()
            } else {

                print("NavitiaSDKPartners/transformAccount: error")

                if data != nil {

                    callbackError(statusCode, [ "error": (data!["reponse"]["compteRendu"]["libelleRetour"].element?.text) ?? "",
                                                "code" : (data!["reponse"]["compteRendu"]["codeRetour"].element?.text) ?? "" ] )
                } else if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {

                    callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {

                    callbackError(statusCode, nil)
                }
            }
        }
    }
    
    public func refreshToken(callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        
        self.refreshToken { (success, statusCode, data) in
            if success {
                callbackSuccess()
            } else {
                callbackError(statusCode, data)
            }
        }
    }

    public func activateAccount( internetAccountId: String, token: String,
                                 callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {

        NavitiaSDKPartnersRequestBuilder.soapPost(stringUrl: "\((configuration as! KeolisAccountManagementConfiguration).url)/socle/\((configuration as! KeolisAccountManagementConfiguration).network)/ActivateAccount/V1.0/", header: _getKeolisHeaderWS(), soapMessage: activateAccountXML(internetAccountId: internetAccountId, token: token)) { (success, statusCode, data) in

            if success {

                print("NavitiaSDKPartners/activateAccount: success")
                callbackSuccess()
            } else {

                print("NavitiaSDKPartners/activateAccount: error")

                if data != nil {

                    callbackError(statusCode, [ "error": (data!["reponse"]["compteRendu"]["libelleRetour"].element?.text) ?? "",
                                                "code" : (data!["reponse"]["compteRendu"]["codeRetour"].element?.text) ?? "" ] )
                } else if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {

                    callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {

                    callbackError(statusCode, nil)
                }
            }
        }
    }

    public func resetPassword( email: String,
                               callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {

        if !(NavitiaSDKPartnersExtension.isValidEmail(str: email)) {
            var data = NavitiaSDKPartnersReturnCode.badParameter.getError()
            var details : [String: Any] = [:]
            details["email"] = NavitiaSDKPartnersParameterCode.invalid
            data["details"] = details
            callbackError(NavitiaSDKPartnersReturnCode.badParameter.getCode(), data)
            return
        } else if email.isEmpty {
            var data = NavitiaSDKPartnersReturnCode.badParameter.getError()
            var details : [String: Any] = [:]
            details["email"] = NavitiaSDKPartnersParameterCode.empty
            data["details"] = details
            callbackError(NavitiaSDKPartnersReturnCode.badParameter.getCode(), data)
            return
        }

        NavitiaSDKPartnersRequestBuilder.soapPost(stringUrl: "\((configuration as! KeolisAccountManagementConfiguration).url)/socle/\((configuration as! KeolisAccountManagementConfiguration).network)/ResetPassword/V1.0/", header: _getKeolisHeaderWS(), soapMessage: resetPasswordXML(email: email)) { (success, statusCode, data) in

            if success {

                print("NavitiaSDKPartners/resetPassword: success")
                callbackSuccess()
            } else {

                print("NavitiaSDKPartners/resetPassword: error")

                if data != nil {
                    if ((data!["reponse"]["compteRendu"]["codeRetour"].element?.text) ?? "") == "0003" {
                        let error = NavitiaSDKPartnersReturnCode.notMatchingAccount
                        callbackError(error.getCode(), error.getError())
                    } else {
                        callbackError(statusCode, [ "error": (data!["reponse"]["compteRendu"]["libelleRetour"].element?.text) ?? "",
                                                "code" : (data!["reponse"]["compteRendu"]["codeRetour"].element?.text) ?? "" ] )
                    }
                } else if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {

                    callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {

                    callbackError(statusCode, nil)
                }
            }
        }
    }

    public func updatePassword( oldPassword : String, newPassword : String,
                                callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String: Any]?) -> Void ) {

        if _accessToken.isEmpty && _refreshToken.isEmpty {
            callbackError(NavitiaSDKPartnersReturnCode.notLogged.getCode(), NavitiaSDKPartnersReturnCode.notLogged.getError())
        }

        updatePassword(oldPassword : oldPassword, newPassword : newPassword) { (success, statusCode, data) in

            if success {
                print("NavitiaSDKPartners/updatePassword: success")
                callbackSuccess()
            } else {
                print("NavitiaSDKPartners/updatePassword: error")
                callbackError( statusCode, data )
            }
        }
    }

    public func getUserInfo( callbackSuccess : @escaping (NavitiaUserInfo) -> Void, callbackError : @escaping (Int, [String: Any]?) -> Void) {

        if _accessToken.isEmpty && _refreshToken.isEmpty {
            callbackError(NavitiaSDKPartnersReturnCode.notLogged.rawValue, ["error" : "Not logged in"])
        }

        self.getUserInfo(tryAccess: true) { success, statusCode, data in
            if success && data != nil {
                let newUserInfo : KeolisUserInfo = KeolisUserInfo()
                newUserInfo.firstName = ((data!["prenom"] as? String ?? "").isEmpty ? "X" : (data!["prenom"] as? String ?? "X"))
                newUserInfo.lastName = ((data!["nom"] as? String ?? "").isEmpty ? "X" : (data!["nom"] as? String ?? "X"))
                newUserInfo.network = data!["filiale"] as? String ?? ""
                newUserInfo.idTechPortal = data!["idTechPortail"] as? String ?? ""
                newUserInfo.accountStatus = KeolisAccountStatus(rawValue : Int(data!["statutCompte"] as? String ?? "0")!)!
                newUserInfo.email = data!["email"] as? String ?? ""
                newUserInfo.courtesy = NavitiaSDKPartnersCourtesy.fromKeolis(str: data!["civilite"] as? String ?? "")
                newUserInfo.country = data!["pays"] as? String ?? ""
                newUserInfo.idTechPortalPerson = data!["idTechPortailPersonne"] as? String ?? ""
                print("NavitiaSDKPartners/getUserInfo: success")
                self.userInfo = newUserInfo
                callbackSuccess(self.userInfo)
            } else {
                print("NavitiaSDKPartners/getUserInfo: error")
                callbackError(statusCode, data)
            }
        }
    }

    public func updateInfo(firstName: String, lastName: String, email: String, birthdate: Date?, courtesy: NavitiaSDKPartnersCourtesy, callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {

        if !(firstName.isEmpty) || !(lastName.isEmpty) || courtesy != .Unknown || (birthdate != nil) {

            updateInfo(firstName: firstName, lastName: lastName, birthdate: birthdate, courtesy: courtesy, completion: { (success, statusCode, data) in
                if (email.isEmpty) {
                    if success {
                        print("NavitiaSDKPartners/updateInfo : success")
                        callbackSuccess()
                    } else {
                        print("NavitiaSDKPartners/updateInfo : error")
                        callbackError(statusCode, data)
                    }
                } else {
                    if !(email.isEmpty) {
                        self.updateEmail(email: email, completion: { (success, statusCode, data) in
                            if success {
                                print("NavitiaSDKPartners/updateInfo : success")
                                callbackSuccess()
                            } else {
                                print("NavitiaSDKPartners/updateInfo : error")
                                callbackError(statusCode, data)
                            }
                        })
                    }
                }
            })
        } else {
            if !(email.isEmpty) {
                updateEmail(email: email, completion: { (success, statusCode, data) in
                    if success {

                        print("NavitiaSDKPartners/updateInfo : success")
                        callbackSuccess()
                    } else {

                        print("NavitiaSDKPartners/updateInfo : error")
                        callbackError(statusCode, data)
                    }
                })
            }
        }
    }

    public func sendActivationEmail(callbackSuccess: @escaping () -> Void, callbackError: @escaping (Int, [String : Any]?) -> Void) {
        NavitiaSDKPartnersRequestBuilder.soapPost(stringUrl: "\((configuration as! KeolisAccountManagementConfiguration).url)/socle/\((configuration as! KeolisAccountManagementConfiguration).network)/UpdateAccount/V1.0/", header: _getKeolisConnectedHeaderWS(), soapMessage: sendActivationEmailXML()) { (success, statusCode, data) in

            if success  {
                print("NavitiaSDKPartners/sendActivationEmail: success")

                callbackSuccess()
            } else {
                print("NavitiaSDKPartners/sendActivationEmail: error")

                if data != nil {

                    callbackError(statusCode, [ "error": (data!["reponse"]["compteRendu"]["libelleRetour"].element?.text) ?? "",
                                                "code" : (data!["reponse"]["compteRendu"]["codeRetour"].element?.text) ?? "" ] )
                } else if NavitiaSDKPartnersReturnCode(rawValue: statusCode) != nil {

                    callbackError(statusCode, NavitiaSDKPartnersReturnCode(rawValue: statusCode)?.getError())
                } else {

                    callbackError(statusCode, nil)
                }
            }
        }
    }
}

extension KeolisAccountManagement {

    internal func getFormattedDate(separated : Bool = true, date : Date = Date()) -> String {

        let calendar = NSCalendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)

        if separated {
            return  "\(year)-\(month < 10 ? "0\(month)" : String(month))-\(day < 10 ? "0\(day)" : String(day))T\(hour < 10 ? "0\(hour)" : String(hour)):\(minute < 10 ? "0\(minute)" : String(minute)):\(seconds < 10 ? "0\(seconds)" : String(seconds))"
        }
        return "\(year)\(month < 10 ? "0\(month)" : String(month))\(day < 10 ? "0\(day)" : String(day))\(hour < 10 ? "0\(hour)" : String(hour))\(minute < 10 ? "0\(minute)" : String(minute))\(seconds < 10 ? "0\(seconds)" : String(seconds))"
    }

    internal func getIdTransaction(numeroFlux : String, ssaEmetteur : String = "WEB") -> String {

        var idTransaction : String = ssaEmetteur
        idTransaction += numeroFlux
        idTransaction += getFormattedDate(separated: false) + "000"
        idTransaction += "001"
        return idTransaction
    }

    internal func createAccountNonAnonymousXML(firstName : String, lastName : String, email : String, birthdate : Date? = nil, password : String, courtesy: String = "") -> String {
        let numeroFlux : String = "INTWSV0019"
        return """
        <?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>
        <question xmlns=\"http://www.keoliscrm.fr/CreerCompteInternetV2/V2.0\" >
        <entete>
        <idTransaction>\(getIdTransaction(numeroFlux: numeroFlux))</idTransaction>
        <numeroFlux>\(numeroFlux)</numeroFlux>
        <siEmetteur>\(_keolisConfiguration?.network ?? "")</siEmetteur>
        <casUsage>CU01</casUsage>\n <ssaEmetteur>VAD</ssaEmetteur>
        <versionFlux>02.10</versionFlux>
        <dateOrigineFlux>\(getFormattedDate())</dateOrigineFlux>
        <ssaRecepteur>\(_keolisConfiguration?.ssaRecepteur ?? "" )</ssaRecepteur>
        <dateTraitementFlux>\(getFormattedDate())</dateTraitementFlux>
        <typeFlux>\(_keolisConfiguration?.typeFlux ?? "")</typeFlux>
        </entete>
        <carte>
        <creation>1</creation>
        <autreReseau>0</autreReseau>
        </carte>
        <compteInternet>
        <email>\(email)</email>
        <motDePasse>\(password)</motDePasse>
        <proprietaireCompteInternet>
        <personnePhysique>
        <canalModification>3</canalModification>
        \(courtesy.isEmpty ? "" : "<civilite>\(courtesy)</civilite>")
        <nom>\(lastName)</nom>
        <prenom>\(firstName)</prenom>
        \(birthdate == nil ? "" : "<dateNaissance>\(getFormattedDate(date: birthdate!))</dateNaissance>")
        <optinSms>0</optinSms>
        <optinEmailCompteWeb>1</optinEmailCompteWeb>
        </personnePhysique>
        </proprietaireCompteInternet>
        </compteInternet>
        </question>
        """
    }

    internal func createAccountAnonymousXML(password : String) -> String {
        let numeroFlux : String = "INTWSV0019"
        return "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>\n<question xmlns=\"http://www.keoliscrm.fr/CreerCompteInternetV2/V2.0\">\n <entete>\n  <idTransaction>\(getIdTransaction(numeroFlux: numeroFlux))</idTransaction>\n<numeroFlux>\(numeroFlux)</numeroFlux>\n  <siEmetteur>\(_keolisConfiguration?.network ?? "")</siEmetteur>\n  <casUsage>TECH</casUsage>\n<ssaEmetteur>VAD</ssaEmetteur>\n<versionFlux>02.00</versionFlux>\n<dateOrigineFlux>\(getFormattedDate())</dateOrigineFlux>\n  <ssaRecepteur>\(_keolisConfiguration?.ssaRecepteur ?? "" )</ssaRecepteur>\n<dateTraitementFlux>\(getFormattedDate())</dateTraitementFlux>\n<typeFlux>\(_keolisConfiguration?.typeFlux ?? "")</typeFlux>\n </entete>\n <compteAnonyme>\n  <motDePasse>\(password)</motDePasse>\n </compteAnonyme>\n</question>"
    }

    internal func activateAccountXML(internetAccountId : String, token : String) -> String {
        let numeroFlux : String = "INTWSV0003"
        return "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>\n<question xmlns=\"http://www.keoliscrm.fr/ActiverCompteInternet/V1.0\"> \n<entete>\n<idTransaction>\(getIdTransaction(numeroFlux:numeroFlux))</idTransaction>\n<numeroFlux>\(numeroFlux)</numeroFlux>\n<siEmetteur>\(_keolisConfiguration?.network ?? "")</siEmetteur>\n<casUsage>CU01</casUsage>\n<ssaEmetteur>MCO</ssaEmetteur>\n<versionFlux>01.00</versionFlux>\n<dateOrigineFlux>\(getFormattedDate())</dateOrigineFlux>\n<ssaRecepteur>\(_keolisConfiguration?.ssaRecepteur ?? "")</ssaRecepteur>\n<dateTraitementFlux>\(getFormattedDate())</dateTraitementFlux>\n<typeFlux>\(_keolisConfiguration?.typeFlux ?? "")</typeFlux>\n</entete>\n<compteInternet>\n<idCompteInternet>\(internetAccountId)</idCompteInternet>\n<cleActivation>\(token)</cleActivation>\n</compteInternet>\n</question>"
    }

    internal func resetPasswordXML(email : String) -> String {
        let numeroFlux : String = "INTWSV0005"
        return "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>\n<question xmlns=\"http://www.keoliscrm.fr/ReinitialiserMotDePasse/V1.0\">\n<entete>\n<idTransaction>\(getIdTransaction(numeroFlux:numeroFlux))</idTransaction>\n<numeroFlux>\(numeroFlux)</numeroFlux>\n<siEmetteur>\(_keolisConfiguration?.network ?? "")</siEmetteur>\n<casUsage>CU01</casUsage>\n<ssaEmetteur>VAD</ssaEmetteur>\n<versionFlux>01.00</versionFlux>\n<dateOrigineFlux>\(getFormattedDate())</dateOrigineFlux>\n<ssaRecepteur>\(_keolisConfiguration?.ssaRecepteur ?? "")</ssaRecepteur>\n<dateTraitementFlux>\(getFormattedDate())</dateTraitementFlux>\n<typeFlux>\(_keolisConfiguration?.typeFlux ?? "")</typeFlux>\n</entete>\n<compteInternet>\n<email>\(email)</email>\n</compteInternet>\n</question>"
    }

    func updatePasswordXML(oldPassword : String, newPassword : String) -> String {
        let numeroFlux : String = "INTWSV0024"
        return "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>\n<question xmlns=\"http://www.keoliscrm.fr/ModifierCompteInternetV2/V2.0\">\n<entete>\n<idTransaction>\(getIdTransaction(numeroFlux:numeroFlux))</idTransaction>\n<numeroFlux>\(numeroFlux)</numeroFlux>\n<siEmetteur>\(_keolisConfiguration?.network ?? "")</siEmetteur>\n<casUsage>CU02</casUsage>\n<ssaEmetteur>VAD</ssaEmetteur>\n<versionFlux>02.10</versionFlux>\n<dateOrigineFlux>\(getFormattedDate())</dateOrigineFlux>\n<ssaRecepteur>\(_keolisConfiguration?.ssaRecepteur ?? "")</ssaRecepteur>\n<dateTraitementFlux>\(getFormattedDate())</dateTraitementFlux>\n<typeFlux>\(_keolisConfiguration?.typeFlux ?? "")</typeFlux>\n</entete>\n<compteInternet>\n<idCompteInternet>\((userInfo as! KeolisUserInfo).idTechPortal)</idCompteInternet>\n<motDePasse>\((oldPassword.encrypt(key: (_keolisConfiguration!).hmacKey))!)</motDePasse>\n<nouveauMotDePasse>\((newPassword.encrypt(key: (_keolisConfiguration!).hmacKey))!)</nouveauMotDePasse>\n</compteInternet>\n</question>"
    }

    internal func getAccountInfoXML() -> String {
        let numeroFlux : String = "INTWSV0020"
        return "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>\n<question xmlns=\"http://www.keoliscrm.fr/RechercherCompteInternetV2/V2.0\">\n<entete>\n<idTransaction>\(getIdTransaction(numeroFlux:numeroFlux))</idTransaction>\n<numeroFlux>\(numeroFlux)</numeroFlux>\n<siEmetteur>\(_keolisConfiguration?.network ?? "")</siEmetteur>\n<casUsage>CU01</casUsage>\n<ssaEmetteur>\(_keolisConfiguration?.ssaEmeteur ?? "")</ssaEmetteur>\n<versionFlux>02.10</versionFlux>\n<dateOrigineFlux>\(getFormattedDate())</dateOrigineFlux>\n<ssaRecepteur>\(_keolisConfiguration?.ssaRecepteur ?? "")</ssaRecepteur>\n<dateTraitementFlux>\(getFormattedDate())</dateTraitementFlux>\n<typeFlux>\(_keolisConfiguration?.typeFlux ?? "")</typeFlux>\n</entete>\n<criteres>\n<idCompteInternet>\((userInfo as! KeolisUserInfo).idTechPortal)</idCompteInternet>\n</criteres>\n</question>\n"
    }

    internal func transformAccountXML(firstName : String, lastName : String, email : String, birthdate : Date? = nil, password : String, courtesy : String = "") -> String {
        let numeroFlux : String = "INTWSV0019"
        return """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <question xmlns="http://www.keoliscrm.fr/CreerCompteInternetV2/V2.0">
        <entete>
        <idTransaction>\(getIdTransaction(numeroFlux:numeroFlux))</idTransaction>
        <numeroFlux>\(numeroFlux)</numeroFlux>
        <siEmetteur>\(_keolisConfiguration?.network ?? "")</siEmetteur>
        <casUsage>CU02</casUsage>
        <ssaEmetteur>VAD</ssaEmetteur>
        <versionFlux>02.00</versionFlux>
        <dateOrigineFlux>\(getFormattedDate())</dateOrigineFlux>
        <ssaRecepteur>\(_keolisConfiguration?.ssaRecepteur ?? "")</ssaRecepteur>
        <dateTraitementFlux>\(getFormattedDate())</dateTraitementFlux>
        <typeFlux>\(_keolisConfiguration?.typeFlux ?? "")</typeFlux>
        </entete>
        <compteInternet>
        <email>\(email)</email>
        <motDePasse>\(password)</motDePasse>
        <proprietaireCompteInternet>
        <personnePhysique>
        <canalModification>3</canalModification>
        \(courtesy.isEmpty ? "" : "<civilite>\(courtesy)</civilite>")
        <nom>\(lastName)</nom>
        <prenom>\(firstName)</prenom>
        \(birthdate == nil ? "" : "<dateNaissance>\(getFormattedDate(date: birthdate!))</dateNaissance>")
        <optinSms>0</optinSms>
        <optinEmailCompteWeb>1</optinEmailCompteWeb>
        </personnePhysique>
        </proprietaireCompteInternet>
        </compteInternet>
        <compteAnonyme>
        <email>\(_anonymousEmail)</email>
        <motDePasse>\(_anonymousPassword.encrypt(key: (_keolisConfiguration?.hmacKey)!)!)</motDePasse>
        </compteAnonyme>
        </question>
        """
    }

    func updateEmailXML(email : String) -> String {
        let numeroFlux : String = "INTWSV0024"
        return """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <question xmlns="http://www.keoliscrm.fr/ModifierCompteInternetV2/V2.0">
        <entete>
        <idTransaction>\(getIdTransaction(numeroFlux:numeroFlux))</idTransaction>
        <numeroFlux>\(numeroFlux)</numeroFlux>
        <siEmetteur>\(_keolisConfiguration?.network ?? "")</siEmetteur>
        <casUsage>CU01</casUsage>
        <ssaEmetteur>VAD</ssaEmetteur>
        <versionFlux>02.10</versionFlux>
        <dateOrigineFlux>\(getFormattedDate())</dateOrigineFlux>
        <ssaRecepteur>\(_keolisConfiguration?.ssaRecepteur ?? "")</ssaRecepteur>
        <dateTraitementFlux>\(getFormattedDate())</dateTraitementFlux>
        <typeFlux>\(_keolisConfiguration?.typeFlux ?? "")</typeFlux>
        </entete>
        <compteInternet>
        <idCompteInternet>\((userInfo as! KeolisUserInfo).idTechPortal)</idCompteInternet>
        <nouvelEmail>\(email)</nouvelEmail>
        <motDePasse>\(_anonymousPassword.encrypt(key: (_keolisConfiguration?.hmacKey)!)!)</motDePasse>
        </compteInternet>
        </question>
        """
    }

    func updateInfoXML(courtesy : String, firstName : String, lastName : String, birthdate : Date?) -> String {
        let numeroFlux : String = "INTWSV0021"
        return """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <question xmlns="http://www.keoliscrm.fr/ModifierPersonneV2/V2.0">
        <entete>
        <idTransaction>\(getIdTransaction(numeroFlux:numeroFlux))</idTransaction>
        <numeroFlux>\(numeroFlux)</numeroFlux>
        <siEmetteur>\(_keolisConfiguration?.network ?? "")</siEmetteur>
        <casUsage>CU01</casUsage>
        <ssaEmetteur>VAD</ssaEmetteur>
        <versionFlux>02.00</versionFlux>
        <dateOrigineFlux>\(getFormattedDate())</dateOrigineFlux>
        <ssaRecepteur>\(_keolisConfiguration?.ssaRecepteur ?? "")</ssaRecepteur>
        <dateTraitementFlux>\(getFormattedDate())</dateTraitementFlux>
        <typeFlux>\(_keolisConfiguration?.typeFlux ?? "")</typeFlux>
        </entete>
        <personnePhysique>
        <idTechnique>\((userInfo as! KeolisUserInfo).idTechPortalPerson)</idTechnique>
        <canalModification>3</canalModification>
        \(courtesy.isEmpty ? "" : "<civilite>\(courtesy)</civilite>")
        \(lastName.isEmpty ? "" : "<nom>\(lastName)</nom>")
        \(firstName.isEmpty ? "" : "<prenom>\(firstName)</prenom>")
        \(birthdate == nil ? "" : "<dateNaissance>\(getFormattedDate(date: birthdate!))</dateNaissance>")
        </personnePhysique>
        </question>
        """
    }

    func sendActivationEmailXML() -> String {
        let numeroFlux : String = "INTWSV0024"
        return """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <question xmlns="http://www.keoliscrm.fr/ModifierCompteInternetV2/V2.0">
            <entete>
                <idTransaction>\(getIdTransaction(numeroFlux:numeroFlux))</idTransaction>
                <numeroFlux>\(numeroFlux)</numeroFlux>
                <siEmetteur>\(_keolisConfiguration?.network ?? "")</siEmetteur>
                <casUsage>CU06</casUsage>
                <ssaEmetteur>VAD</ssaEmetteur>
                <versionFlux>02.10</versionFlux>
                <dateOrigineFlux>\(getFormattedDate())</dateOrigineFlux>
                <ssaRecepteur>\(_keolisConfiguration?.ssaRecepteur ?? "")</ssaRecepteur>
                <dateTraitementFlux>\(getFormattedDate())</dateTraitementFlux>
                <typeFlux>\(_keolisConfiguration?.typeFlux ?? "")</typeFlux>
            </entete>
            <compteInternet>
                <idCompteInternet>\((userInfo as! KeolisUserInfo).idTechPortal)</idCompteInternet>
            </compteInternet>
        </question>
        """
    }
}
