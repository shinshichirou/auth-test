//
//  YahooWebProvider.swift
//  auth-test
//
//  Created by Igor Tudoran on 22.03.2018.
//  Copyright © 2018 Igor Tudoran. All rights reserved.
//

import Foundation

class YahooWebProvider: YahooProvider {
    
    private typealias CodeCompletion = (_ code: String?, _ error: AuthorizeError?) -> Void
    private typealias TokenCompletion = (_ parameters: [String: Any]?, _ error: AuthorizeError?) -> Void
    
    public override func authorize(_ completion: @escaping Providing.Completion) {
        
        authorizeAccess { code, error in
            guard let code = code else {
                completion(nil, error)
                return
            }
            
            self.token(withCode: code, { (parameters, error) in
                guard let parameters = parameters else {
                    completion(nil, error)
                    return
                }
                
                let user = User(id: "no id",
                                name: "no name",
                                additions: ["no key": "no value"])
                
                let session = Session(token: parameters["access_token"]! as! String,
                                      user: user,
                                      additions: parameters)
                completion(session, nil)
            })
        }
    }
    
    private func authorizeAccess(_ completion: @escaping CodeCompletion) {
        let parameters = ["client_id": client.id,
                          "response_type": "code",
                          "redirect_uri": redirectUri.encoded]
        let url = URL(string: "https://api.login.yahoo.com/oauth2/request_auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.string.data(using: .utf8)
        
        WebRequestService.load(request, ofProvider: self) { url, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            if let parameters = url!.absoluteString.components(separatedBy: "?").last,
                parameters.dictionary["error"] != nil {
                
                completion(nil, AuthorizeError.cancel)
            } else if let parameters = url!.absoluteString.components(separatedBy: "?").last,
                let code = parameters.dictionary["code"] {
                
                completion(code, nil)
            } else {
                print(AuthorizeError.parseMessage)
                completion(nil, AuthorizeError.parse)
            }
        }
    }
    
    private func token(withCode code: String, _ completion: @escaping TokenCompletion) {
        let parameters = ["client_id": client.id,
                          "client_secret": client.secret,
                          "grant_type": "authorization_code",
                          "code": code,
                          "redirect_uri": redirectUri.encoded]
        
        let url = URL(string: "https://api.login.yahoo.com/oauth2/get_token")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.string.data(using: .utf8)
        
        URLSession.resumeDataTask(with: request) { data, error in
            guard let data = data,
                let parameters = try? JSONSerialization.jsonObject(with: data) as! [String: Any],
                parameters["access_token"] != nil,
                parameters["refresh_token"] != nil,
                parameters["expires_in"] != nil,
                parameters["token_type"] != nil else {
                    
                    if error == nil {
                        print(AuthorizeError.parseMessage)
                    }
                    
                    completion(nil, error ?? AuthorizeError.parse)
                    return
            }
            
            completion(parameters, nil)
        }
    }
    
}

