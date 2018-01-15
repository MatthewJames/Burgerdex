//
//  Burger.swift
//  Burgerdex
//
//  Created by Matthew Sullivan on 2018-01-03.
//  Copyright © 2018 Dev & Barrel Inc. All rights reserved.
//

import UIKit

//Only using protocol and : BurgerObject on multiple classes due to using multiple different object types in a table view.
//Instead of class BurgerPreview : BurgerObject { syntax, use class BurgerPreview { elsewhere
protocol BurgerObject {
    
}

class BurgerPreview : BurgerObject {

    var name: String
    var kitchen: String
    var catalogueNumber: Int
    var burgerID: Int
    var photoUrl: String
    var photo: UIImage
    
    init?(name: String, kitchen: String, catalogueNumber: Int, photoUrl: String, photo: UIImage, burgerID: Int) {
        
        if name.isEmpty || kitchen.isEmpty || catalogueNumber < 0 || burgerID < 0 {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.kitchen = kitchen
        self.catalogueNumber = catalogueNumber
        self.burgerID = burgerID
        self.photoUrl = photoUrl
        self.photo = photo
        
    }
    
    class func generatePlaceholderBurgers() ->Array<Any>{
        
        var patties = [BurgerPreview]()
        
        for _ in 1...10 {
            
            guard let burgerPlaceholder = BurgerPreview.init(name:"Bacon Beast",
                                                        kitchen: "Burger Delight",
                                                catalogueNumber: 0,
                                                       photoUrl: "baconBeast",
                                                          photo:UIImage(),
                                                       burgerID: 0)else{
                                                    
                                                    fatalError("Unable to instantiate burgerPreview")
            }
            
            patties += [burgerPlaceholder]
            
        }
        
        return patties
        
    }
    
    class func fetchBurgerPreviews(page: Int, filter: Int, completion:@escaping (_ resultPatties:Array<Any>)->Void){
        
        var patties = [BurgerPreview]()
        
        //let postURL = URL(string: "https://www.app.burgerdex.ca/services/allBurgers.php")!
        
        let url = "https://www.app.burgerdex.ca/services/allBurgers.php?page=1&filter="
        
        let path = url + String(filter)
        
        let postURL = URL(string: path)!
        
        print(postURL)
        
        var postRequest = URLRequest(url: postURL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60.0)
        
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        postRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let parameters: [String: Any] = ["page": String(page), "filter": String(filter)]
        
        do {
            let jsonParams = try JSONSerialization.data(withJSONObject: parameters, options: [])
            postRequest.httpBody = jsonParams
            
        } catch { print("Error: unable to add parameters to POST request.")}
        
        URLSession.shared.dataTask(with: postRequest, completionHandler: { (data, response, error) -> Void in
            
            if error != nil { print("POST Request: Communication error: \(error!)") }
            
            if data != nil {
                
                do {
                   
                    if let burgerResults = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
        
                        DispatchQueue.main.async(execute: {
                        
                            if let burgers = burgerResults["burgers"] as? [[String: Any]] {
                                
                                for burger in burgers {
                                    
                                    let name = burger["name"] as? String
                                    let kitchen = burger["kitchen"] as? String
                                    let imagePath = burger["image"] as? String
                                    let catalogueNumber = burger["id"] as? Int
                                    let imageOrigin = "https://burgerdex.ca/"
                                    
                                    let pattyImagePath = imageOrigin + imagePath!
                                    
                                    guard let burgerPreview = BurgerPreview.init(name: name!,
                                                                                 kitchen: kitchen!,
                                                                                 catalogueNumber: catalogueNumber!,
                                                                                 photoUrl: pattyImagePath,
                                                                                 photo:UIImage(),
                                                                                 burgerID: catalogueNumber!)else{
                                        fatalError("Unable to instantiate burgerPreview")
                                    }
                                    
                                    patties += [burgerPreview]
                                }
                                completion(patties)
                            }
                            
                        } as @convention(block) () -> Void)
                    }
        
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
            
            } else {
                DispatchQueue.main.async(execute: {
                    print("Received empty response.")
                })
            }
        }).resume()
        
    }
}

class Burger : BurgerObject{
    
    var name: String
    var kitchen: String
    var catalogueNumber: Int
    var descript: String
    var burgerID: Int
    var location: String
    var rating: String
    var price: String
    var ingredients: String
    var fusion: Bool
    var fused: [Dictionary<String, AnyObject>]
    var veggie: Bool
    var spicy: Bool
    var extinct: Bool
    var seasonal: Bool
    var hasChallenge: Bool
    var hasMods: Bool
    var dateCaptured: String
    
    init?(name: String,
         kitchen: String,
         catalogueNumber: Int,
         descript: String,
         burgerID: Int,
         location: String,
         rating: String,
         price: String,
         ingredients: String,
         fusion: Bool,
         fused: [Dictionary<String, AnyObject>],
         veggie: Bool,
         spicy: Bool,
         extinct: Bool,
         seasonal: Bool,
         hasChallenge: Bool,
         hasMods: Bool,
         dateCaptured: String) {
        
        // Initialize stored properties.
        self.name = name
        self.kitchen = kitchen
        self.catalogueNumber = catalogueNumber
        self.descript = descript
        self.burgerID = burgerID
        self.location = location
        self.rating = rating
        self.price = price
        self.ingredients = ingredients
        self.fusion = fusion
        self.fused = fused
        self.veggie = veggie
        self.spicy = spicy
        self.extinct = extinct
        self.seasonal = seasonal
        self.hasChallenge = hasChallenge
        self.hasMods = hasMods
        self.dateCaptured = dateCaptured
        
    }
    
    class func generateBurgerPlaceholderInformation() ->Burger{
        
        guard let burgerPlaceholder = Burger.init(name: "Bacon Beast",
                                           kitchen: "Burger Delight",
                                           catalogueNumber: 0,
                                           descript: "Best burger in Clarington, hands down. The bacon on this burger is the best bacon I have ever eaten. You have to try this burger.\n\n \n\n$17 CAD because of poutine combo.",
                                           burgerID: 0,
                                           location: "Clarington",
                                           rating: "9.2",
                                           price: "CAD $17.00",
                                           ingredients: "BBQ Sauce \n\n Fresh (never frozen, delivered that day) double patty \n\n Bacon \n\n Cheese \n\n standard toppings of your choice.",
                                           fusion: false,
                                           fused: [],
                                           veggie: false,
                                           spicy: false,
                                           extinct: false,
                                           seasonal: false,
                                           hasChallenge: false,
                                           hasMods: false,
                                           dateCaptured: "2017-10-18 08:08:59") else {
                                            
                                            fatalError("Unable to instantiate burger")
        }
        
        return burgerPlaceholder
        
    }
    
    class func fetchBurgerDetails(burgerID: Int, completion:@escaping (_ pattyInformation:Burger)->Void){
        
        let url = "https://www.app.burgerdex.ca/services/burgerDetail.php?id="

        let path = url + String(burgerID)
       
        let postURL = URL(string: path)!
        
        var postRequest = URLRequest(url: postURL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60.0)
        
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        postRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let parameters: [String: Any] = ["id": String(burgerID)]
        
        do {
            let jsonParams = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            postRequest.httpBody = jsonParams
            
        } catch { print("Error: unable to add parameters to POST request.")}
        
        URLSession.shared.dataTask(with: postRequest, completionHandler: { (data, response, error) -> Void in
            
            print(postRequest)
            
            if error != nil { print("POST Request: Communication error: \(error!)") }
            
            if data != nil {
                
                do {
                    
                    if let burgerResults = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        DispatchQueue.main.async(execute: {
                            
                            if let burgers = burgerResults["burger"] as? [[String: Any]] {
                                
                                for burger in burgers {
                                    
                                    let name = burger["name"] as? String
                                    let kitchen = burger["kitchen"] as? String
                                    let descript = burger["description"] as? String
                                    let locations = burger["locations"] as? String
                                    let rating = burger["rating"] as? String
                                    let price = burger["price"] as? String
                                    let ingredients = burger["ingredients"] as? String
                                    let dateCaptured = burger["dated"] as? String
                                    let catalogueNumber = burger["id"] as? Int
                                    let fusion = burger["fusion"] as? Bool
                                    let fused = burger["fused"] as? [Dictionary<String, AnyObject>]
                                    let veggie = burger["veggie"] as? Bool
                                    let spicy = burger["spicy"] as? Bool
                                    let extinct = burger["extinct"] as? Bool
                                    let seasonal = burger["seasonal"] as? Bool
                                    let hasChallenge = burger["hasChallenge"] as? Bool
                                    let hasMods = burger["hasMods"] as? Bool
                                    
                                    guard let burgerInfo = Burger.init(name: name!,
                                                                       kitchen: kitchen!,
                                                                       catalogueNumber: catalogueNumber!,
                                                                       descript: descript!,
                                                                       burgerID: catalogueNumber!,
                                                                       location: locations!,
                                                                       rating: rating!,
                                                                       price: price!,
                                                                       ingredients: ingredients!,
                                                                       fusion: fusion!,
                                                                       fused: fused!,
                                                                       veggie: veggie!,
                                                                       spicy: spicy!,
                                                                       extinct: extinct!,
                                                                       seasonal: seasonal!,
                                                                       hasChallenge: hasChallenge!,
                                                                       hasMods: hasMods!,
                                                                       dateCaptured: dateCaptured!)else {
                                                                        
                                                                        fatalError("Unable to instantiate burger")
                                    }
                                    
                                     completion(burgerInfo)
                                }
                                
                               
                            }
                            
                            } as @convention(block) () -> Void)
                    }
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
            } else {
                DispatchQueue.main.async(execute: {
                    print("Received empty response.")
                })
            }
        }).resume()
        
    }
    
}

class Badge : BurgerObject{
    
    var ratingTitle: String
    var badgeTitle: String
    var badgeIcon: UIImage
    
    init?(ratingTitle: String,
          badgeTitle: String,
          badgeIcon: UIImage) {
        
        // Initialize stored properties.
        self.ratingTitle = ratingTitle
        self.badgeTitle = badgeTitle
        self.badgeIcon = badgeIcon
        
    }
    
}