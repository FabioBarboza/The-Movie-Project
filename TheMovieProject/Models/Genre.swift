//
//  Genre.swift
//  TheMovieProject
//
//  Created by Fabio Barboza on 03/11/16.
//  Copyright © 2016 Kobe. All rights reserved.
//

import Foundation

struct GenreConstants {
    static let name = "name"
    static let objectId = "id"
}

class Genre {
    let name: String
    let objectID: Int
    
    init(name: String, objectID: Int) {
        self.name = name
        self.objectID = objectID
    }
    
    convenience init?(json: [String: AnyObject]) {
        guard let name = json[GenreConstants.name] as? String,
        let objectID = json[GenreConstants.objectId] as? Int
            else { return nil}
        self.init(name: name, objectID: objectID)
    }
}
