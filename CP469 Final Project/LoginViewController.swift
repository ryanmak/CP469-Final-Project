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
            // exit the webview, we no longer need it
            navigationController?.popViewController(animated: true)
            
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
                a.getToken()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
