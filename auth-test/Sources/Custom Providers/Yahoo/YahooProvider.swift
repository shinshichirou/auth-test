//
//  YahooProvider.swift
//  auth-test
//
//  Created by Igor Tudoran on 21.03.2018.
//  Copyright © 2018 Igor Tudoran. All rights reserved.
//

import Foundation

class YahooProvider: Provider {
    
    typealias Client = (id: String, secret: String)
    
    override var name: String {
        return "Yahoo"
    }
    
    var client: Client {
        return (id: options["clientId"] as! String, secret: options["clientSecret"] as! String)
    }
    
    public required init?() {
        super.init()
        
        guard options["clientId"] != nil, options["clientSecret"] != nil else {
            
            if options["clientId"] == nil {
                print("There is no client id in \(name).plist file")
            } else {
                print("There is no client secret in \(name).plist file")
            }
            
            return nil
        }
    }
    
}
