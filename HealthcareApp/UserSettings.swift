//
//  UserSettings.swift
//  HealthcareApp
//
//  Created by mac on 5/16/18.
//  Copyright © 2018 mobileappscompany. All rights reserved.
//

import Foundation


class UserSettings {
    
    struct Keys {
        static let service = "MyService"
        static let username = "username"
        static let rememberMe = "RememberMe"
    }
    
    static var rememberMePreference:Bool = false
    
    class func storedUserName()->String? {
        return UserDefaults.standard.object(forKey: Keys.username) as? String
    }
    
    class func login(username: String, password: String) -> Bool {
        
        // read the stored username and make sure it matches
        guard let storedUsername = storedUserName(),
            username == storedUsername else { return false }
        
        // read the stored password
        guard let storedPassword = try? KeychainPasswordItem(service: Keys.service, account: username).readPassword() else { return false }
        
        // return true if the given password matches and false otherwise
        return (password == storedPassword)
    }
    
//    class func saveUsername(_ username: String){
//        UserDefaults.standard.set(username, forKey: Keys.username)
//    }
    
    class func saveRememberMePreference(state:Bool)
    {
        UserDefaults.standard.set(state, forKey: UserSettings.Keys.rememberMe)
    }
    class func fetchRememberMePreference()->Bool{
        
        guard let userNameSavePreference = UserDefaults.standard.value(forKey: Keys.rememberMe)
        else {return true}
        
        rememberMePreference = userNameSavePreference as! Bool
        return rememberMePreference
        
    }
    
    
    class func saveLogin(username: String, password: String){
        //UserDefaults.standard.set(, forKey: <#T##String#>)
        do {
            // store username
            UserDefaults.standard.set(
                username,
                forKey: Keys.username)

            // encrypt and store password, associate with username
            try KeychainPasswordItem(
                service: Keys.service,
                account: username).savePassword(password)
        }catch {
            print("Could not save login info")
        }
    }
    
}
