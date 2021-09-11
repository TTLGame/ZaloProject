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
    init() {
        dataAPI = []
        userLike = []
    }
    func loadData(APIUrl: String) throws{
        let semaphore = DispatchSemaphore(value: 0)
        let url = APIUrl + "&" + "client_id=" + authenication
        //let url = "https://reqres.in/api/users?page=1"
        guard let unwrappedUrl =  URL(string:url) else { throw DataError.failToUnwrapItems}
        //read JSON API data
        let task = URLSession.shared.dataTask(with: unwrappedUrl){
            data, response, error in
            if (error == nil){
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
                semaphore.signal()
            }
        }
        task.resume()
        semaphore.wait()
    }
}
