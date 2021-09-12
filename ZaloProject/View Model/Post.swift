//
//  Post.swift
//  ZaloProject
//
//  Created by geotech on 11/09/2021.
//

import Foundation
class Post{
    var imageUrl: String
    var userName: String
    var totalLikes: Int
    init(value: [String: Any]){
        //unwrwap user name
        let username = value["user"] as? [String:Any]
        self.userName = username?["name"] as? String ?? "Username"
        
        self.totalLikes = value["likes"] as? Int ?? 0
        
        // unwrap image url
        let url = value["urls"] as? [String:Any]
        self.imageUrl = url?["full"] as? String ?? ""
    }
}
