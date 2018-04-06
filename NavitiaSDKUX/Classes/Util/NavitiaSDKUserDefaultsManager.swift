//
//  NavitiaSDKUserDefaultsManager.swift
//  NavitiaSDKUX
//

import Foundation

open class NavitiaSDKUserDefaultsManager {
    open static let SHOW_REDIRECTION_DIALOG_PREF_KEY = "navitiaSdkShowRedirectionDialog"
    open static let SHOW_REDIRECTION_DIALOG_DEF_VALUE = true
    
    open static func resetUserDefaults() {
        UserDefaults.standard.set(SHOW_REDIRECTION_DIALOG_DEF_VALUE, forKey: SHOW_REDIRECTION_DIALOG_PREF_KEY)
        UserDefaults.standard.synchronize()
    }
    
    open static func saveUserDefault(key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
