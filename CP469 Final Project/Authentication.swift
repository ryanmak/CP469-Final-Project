//
//  Authentication.swift
//  CP469 Final Project
//
//  Created by Ryan Mak on 2018-04-06.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit

// SINGLETON OBJECT
class Authentication {
    // https://www.reddit.com/api/v1/authorize?client_id=CLIENT_ID&response_type=TYPE&state=RANDOM_STRING&redirect_uri=URI&duration=DURATION&scope=SCOPE_STRING
    let client_id = "MngzElegS5eKFw"
    let type = "code"
    let state = "cp469finalprojectredditapp"
    let redirect_uri = "https://ryanmak.github.io/CP469-Final-Project/"
    let duration = "permanent"
    let scope = "read"
    var url = ""
    var responseCode = ""
    var isAuthenticated:Bool = false
    var token = ""
    
    static let sharedInstance: Authentication = {
        let instance = Authentication()
        return instance
    }()
    
    private init() {
        print("Authentication")
        
        // build url
        url = "https://www.reddit.com/api/v1/authorize.compact" +
        "?client_id=" + client_id +
        "&response_type=" + type +
        "&state=" + state +
        "&redirect_uri=" + redirect_uri +
        "&duration=" + duration +
        "&scope=" + scope
    }
}
