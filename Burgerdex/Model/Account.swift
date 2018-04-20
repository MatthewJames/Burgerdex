//
//  Account.swift
//  Burgerdex
//
//  Created by Matthew Sullivan on 2018-01-03.
//  Copyright © 2018 Dev & Barrel Inc. All rights reserved.
//

import UIKit
/*
    If the version number directory is different than the current version of the app, this indicates that the old service folder is fine to use with the current app version we are on. This stops us from having to create multiple directories on the server for any small bug fix or enhancement. As well as if we didn't update the service code.
 */
private let versionNumber = "1.1.0"

private let kUploadToken = "https://www.app.burgerdex.ca/services/ios/apns/send_token.php"

class Account  {
    
    class func insertToken(token: String, session: URLSession,completion:@escaping (_ resultPatties:Array<Any>)->Void){
        
        print("GOT HERE METHOD CALL")
        
        //Start by invalidating on going long tasks
        session.invalidateAndCancel()
        
        var tokenResponseData = [0,"Error"] as [Any]
    
        let url = kUploadToken
        
        var postRequest = URLRequest(url: URL(string:url)!,
                                     cachePolicy: .reloadIgnoringCacheData,
                                     timeoutInterval: 60.0)
        
        let parameters: [String: Any] = ["action": "insert-token", "token": String(token)]
        
        do {
            
            let jsonParams = try JSONSerialization.data(withJSONObject: parameters, options:[])
            
            postRequest.httpBody = jsonParams
            
            
        } catch { print("Error: unable to add parameters to POST request.")}
        
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        postRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: postRequest, completionHandler: { (data, response, error) -> Void in
            
            if error != nil { print("POST Request: Communication error: \(error!)") }
            
            if data != nil {
                
                do {
                    
                    if let tokenResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        print(tokenResponse)
                        
                        DispatchQueue.main.async(execute: {
                            
                            let message = tokenResponse["message"] as! String
                            let successCode = tokenResponse["success"] as! Int
                            
                            if  successCode == 0 {
                                
                                print(message);
                                
                                tokenResponseData[0] = 0
                
                                completion(tokenResponseData)
                                
                                
                            }else{
                                
                                // Good to go
                                print(message);
                                
                                tokenResponseData[0] = 1
                                
                                completion(tokenResponseData)
                                
                            }
                            
                        } as @convention(block) () -> Void)
                    }
                    
                } catch {
                    
                    print("Error deserializing JSON: \(error)")
                    
                    tokenResponseData[0] = 0
            
                    DispatchQueue.main.async(execute: {
                        completion(tokenResponseData)
                        
                    })
                    
                }
                
            } else {
                
                tokenResponseData[0] = 1
        
                DispatchQueue.main.async(execute: {
                    print("Received empty response.")
                    
                    completion(tokenResponseData)
                    
                })
            }
            
        }).resume()
        
    }
    
}