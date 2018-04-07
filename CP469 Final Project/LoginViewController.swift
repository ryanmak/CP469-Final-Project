//
//  LoginViewController.swift
//  CP469 Final Project
//
//  Created by Ryan Mak on 2018-04-06.
//  Copyright © 2018 Mak & Wu Collaborative. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    let a = Authentication.sharedInstance
    @IBOutlet weak var webView: WKWebView!
    var rawData = NSData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(a.url)
        
        // open a webview so that the user can allow this app to access their account
        let myURL = URL(string: a.url)
        let myRequest = URLRequest(url: myURL!)
        webView.navigationDelegate = self
        webView.load(myRequest)
    }
    
    // function runs when webpage has fully loaded
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // print("loaded aaaaaaaaa")
        let currentURL = String(describing: webView.url!)
        print(currentURL)
        
        // test if user has successfully logged in
        let index = currentURL.index(currentURL.startIndex, offsetBy: 25)
        if (currentURL.prefix(upTo: index) == "https://ryanmak.github.io") {
            //print("when u walkin 👌🏻👌🏻")
            // extract the parameters in the url. used for getting the user token
            // state
            var x = substring(searchText: currentURL, searchTerm: "state")
            x = x + 6
            
            // code
            var y = substring(searchText: currentURL, searchTerm: "code")
            y = y + 5
            
            // used another GitHub project for easier string slicing. Credits go to:
            // https://github.com/frogcjn/OffsetIndexableCollection-String-Int-Indexable-
            // for providing a simple and easy way to slice strings
            let state = currentURL[x...(x+25)]
            let code = currentURL[y...]
            a.responseCode = String(describing:code)
            
            if (state == a.state) {
                print("state is the same")
                getToken()
            }
            else{
                navigationController?.popViewController(animated: true)
            }
        }
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
        let username = a.client_id
        let password = ""
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        // set the data above as the http header
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // insert the given code from the webview
        let postCode = "grant_type=authorization_code&code=" + a.responseCode + "&redirect_uri=" + a.redirect_uri
        request.httpBody = postCode.data(using: .utf8)
        
        let task = session.dataTask(with: request) {( data, response, error) in
            print("sup")
            self.rawData = NSData(data:data!)
            let results = NSString(data: self.rawData as Data, encoding: String.Encoding.utf8.rawValue)
            print(results ?? "no")
            
            // parse json
            var json:[String:Any]? = nil
            do {
                json = try JSONSerialization.jsonObject(with: self.rawData as Data, options:.allowFragments) as? [String:Any]
            } catch {
                print("Error Parsing JSON")
                print(error)
            }
            self.a.token = json!["access_token"] as! String
            print(self.a.token)
            self.a.isAuthenticated = true
            print("exit")
            
            DispatchQueue.main.async {
                _ = self.navigationController?.popViewController(animated: true)
            }
            print("exited")
        }
        task.resume()
    }
    
    // returns the starting index of the given search term from the given search sentence
    func substring(searchText:String, searchTerm:String)->Int{
        var searchRange = searchText.startIndex..<searchText.endIndex
        var ranges: [Range<String.Index>] = []
        
        while let range = searchText.range(of: searchTerm, range: searchRange) {
            ranges.append(range)
            searchRange = range.upperBound..<searchRange.upperBound
        }
        var v = String(describing: ranges.map { searchText.distance(from: searchText.startIndex, to: $0.lowerBound)})
        v.removeLast()
        v.removeFirst()
        
        return Int(v)!
    }
}
