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

class Genre: NSObject, NSCoding {
    let name: String
    let objectId: Int
    
    init(name: String, objectId: Int) {
        self.name = name
        self.objectId = objectId
    }
    
    convenience init?(json: [String: AnyObject]) {
        guard let name = json[GenreConstants.name] as? String,
        let objectID = json[GenreConstants.objectId] as? Int
            else { return nil }
        self.init(name: name, objectId: objectID)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: GenreConstants.name) as? String
            else { return nil }
        let objectId = aDecoder.decodeInteger(forKey: GenreConstants.objectId)
        self.init(name: name, objectId: objectId)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: GenreConstants.name)
        aCoder.encode(objectId, forKey: GenreConstants.objectId)
    }
    
    
}
