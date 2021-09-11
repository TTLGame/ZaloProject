//
//  ReadAndFetchData.swift
//  ZaloProject
//
//  Created by geotech on 11/09/2021.
//

import Foundation
class ReadAndFetchData{
    
    
    let authenication = "7MW37N9mstsXcGjqgWAOoicbLsfY6OxEr_9NQ46IBR8"
    var dataAPI:[Post]
    var userLike:[Int]
    
    //start data
    var currentPage = 1
    init() {
        dataAPI = []
        userLike = []
    }
    
    //reset data
    func reset(){
        dataAPI = []
        userLike = []
    }
    
    // load default data
    func loadDefaultData(data:Data?)throws {
        do{
            let jsonValue = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]]
            guard let jsonValueUnwrapped = jsonValue else{ throw DataError.failToUnwrapItems}
           
            for i in 0..<jsonValueUnwrapped.count{
                let newPost = Post(value: jsonValueUnwrapped[i])
                self.dataAPI.append(newPost)
                self.userLike.append(0)
            }
        }
        catch{print("Error")}
    }
    
    //load search data
    func loadSearchData(data:Data?) throws{
        do{
            let jsonValue = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
            guard let jsonValueUnwrapped = jsonValue else{ throw DataError.failToUnwrapItems}
           
            // get search results data
            let convertJsonValue = jsonValueUnwrapped["results"] as? [[String:Any]]
            guard let convertJsonValueUnwrapped = convertJsonValue else{ throw DataError.failToUnwrapItems}
            
            for i in 0..<convertJsonValueUnwrapped.count{
                let newPost = Post(value: convertJsonValueUnwrapped[i])
                self.dataAPI.append(newPost)
                self.userLike.append(0)
            }
        }
        catch{print("Error")}
    }
    //load data
    func loadData(type: Int, APIUrl: String) throws{
        let semaphore = DispatchSemaphore(value: 0)
        let url = APIUrl + String(describing: currentPage) + "&" + "client_id=" + authenication
        
        //move to next page
        currentPage += 1
        
        guard let unwrappedUrl =  URL(string:url) else { throw DataError.failToUnwrapItems}
        //read JSON API data
        print(unwrappedUrl)
        let task = URLSession.shared.dataTask(with: unwrappedUrl){
            data, response, error in
            if (error == nil){
                if (type == 1){
                    do {
                        try self.loadDefaultData(data: data)
                    } catch DataError.failToUnwrapItems {
                        print("Fail to unwrap item")
                    }
                    catch{ print("Fail to load data")}
                }
                else {
                    do {
                        try self.loadSearchData(data: data)
                    } catch DataError.failToUnwrapItems {
                        print("Fail to unwrap item")
                    }
                    catch{ print("Fail to load data")}
                }
                semaphore.signal()
            }
        }
        task.resume()
        semaphore.wait()
    }
}
