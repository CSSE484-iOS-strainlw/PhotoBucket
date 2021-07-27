//
//  PhotoBucket.swift
//  PhotoBucket
//
//  Created by Loki Strain on 7/26/21.
//

import Foundation
import Firebase

class PhotoBucket {
    var url: String
    var caption: String
    var id: String?
    
    init(url: String, caption: String){
        self.url = quote
        self.caption = movie
    }
    init(documentSnapshot: DocumentSnapshot){
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()!
        self.url = data["url"] as! String
        self.caption = data["caption"] as! String
    }
}
