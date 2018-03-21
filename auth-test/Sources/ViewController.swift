//
//  ViewController.swift
//  auth-test
//
//  Created by Igor Tudoran on 19.03.2018.
//  Copyright © 2018 Igor Tudoran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DebugService.isNeedOutput = true
    }
    
    private func authorizeWith(_ provider: Provider) {
        provider.authorize { session, error in
            guard let session = session else {
                print("Problem with \(error!)")
                return
            }
            
            print("Authorized with \(provider.name)")
            print("Info: \(session)")
        }
    }
    
    // Working:
    
    @IBAction func yahooPressed(_ sender: Any) {
        if let provider = YahooWebProvider() {
            authorizeWith(provider)
        }
    }
    
    @IBAction func linkedIndPressed(_ sender: Any) {
        if let provider = LinkedInWebProvider() {
            authorizeWith(provider)
        }
    }
    
    @IBAction func twitterPressed(_ sender: Any) {
        if let provider = TwitterWebProvider() {
            authorizeWith(provider)
        }
    }
    
    @IBAction func instagramPressed(_ sender: Any) {
        if let provider = InstagramWebProvider() {
            authorizeWith(provider)
        }
    }
    
    // Not working:
    
    @IBAction func facebookPressed(_ sender: Any) {
        if let provider = FacebookWebProvider() {
            authorizeWith(provider)
        }
    }
    
    @IBAction func googlePressed(_ sender: Any) {
        if let provider = GoogleWebProvider() {
            authorizeWith(provider)
        }
    }
}

