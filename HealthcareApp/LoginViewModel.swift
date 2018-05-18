//
//  LoginViewModel.swift
//  HealthcareApp
//
//  Created by mac on 5/16/18.
//  Copyright © 2018 mobileappscompany. All rights reserved.
//

import Foundation
//import RxSwift
//import RxCocoa

protocol LoginViewModelDelegate: class {
    
    func stateChanged(to state: LoginViewModel.State)
}


@objcMembers class LoginViewModel: NSObject {
    
    
    @objc enum State: Int {
        case initial
        case waiting
        case invalid
        case authenticated
    }
    
    @objc dynamic var buttonText: String = "Login"
    @objc dynamic var username: String = ""
    
    var registered: Bool = false {
        didSet {
            if registered {
                handledRegistered()
            }else {
                handleUnRegistered()
            }
        }
    }
    
    weak var delegate: LoginViewModelDelegate?
    
    var state: State {
        didSet{
            delegate?.stateChanged(to: state)
        }
    }
    
    override init() {
        self.state = .initial
        registered = (UserSettings.storedUserName() != nil)
        super.init()

        if registered {
            handledRegistered()
        }else {
            handleUnRegistered()
        }
    }
    
    func handledRegistered(){
        buttonText = "Login"
        username = UserSettings.storedUserName() ?? ""
    }
    
    func handleUnRegistered(){
        buttonText = "Register"
    }
    
    func saveRememberMeUserPreference(state:Bool)
    {
        UserSettings.saveRememberMePreference(state: state)
        //rememberMe = state
    }
    func fetchRememberMe()->Bool{
        
        return UserSettings.fetchRememberMePreference()
        
    }
    
    func login(username: String, password: String){
        state = .waiting
        if !registered {
            // user is signing up
            UserSettings.saveLogin(username: username, password: password)
        }else {
            // user is trying to log in
            if UserSettings.login(username: username, password: password){
                state = .authenticated
                
            }else {
                state = .invalid
            }
        }
    }
}
