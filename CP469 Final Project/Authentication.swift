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
    
    var rawData = NSData()
    
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
    
    // get token from reddit server
    func getToken(){
        print("get token")
        let url = URL(string: "https://www.reddit.com/api/v1/access_token")!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // give a POST request to the server
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Authorization: Basic HTTP Auth header
        let username = client_id
        let password = ""
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        // set the data above as the http header
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // insert the given code from the webview
        let postCode = "grant_type=authorization_code&code=" + responseCode + "&redirect_uri=" + redirect_uri
        request.httpBody = postCode.data(using: .utf8)
        
        let task = session.dataTask(with: request) {( data, response, error) in
            print("sup")
            self.rawData = NSData(data:data!)
            let results = NSString(data: self.rawData as Data, encoding: String.Encoding.utf8.rawValue)
            print(results ?? "no")
            self.isAuthenticated = true
            
            // parse json
            var json:[String:Any]? = nil
            do {
                json = try JSONSerialization.jsonObject(with: self.rawData as Data, options:.allowFragments) as? [String:Any]
            } catch {
                print("Error Parsing JSON")
                print(error)
            }
            self.token = json!["access_token"] as! String
            print(self.token)
        }
        task.resume()
    }
}
