//
//  AppSettings.swift
//  TheMovieProject
//
//  Created by Fabio Barboza on 03/11/16.
//  Copyright © 2016 Kobe. All rights reserved.
//

import Foundation

struct AppSettings {
    static let apiKey = "1f54bd990f1cdfb230adb312546d765d"
    static let baseURL = "https://api.themoviedb.org/3/"
    static let defaults = UserDefaults.standard
    static let genresKey = "genres"
    static let language = "en-US"
    
    static func store(genres: [Int:Genre]) {
        let data = NSKeyedArchiver.archivedData(withRootObject: genres)
        defaults.set(data, forKey: genresKey)
        defaults.synchronize()
    }
    
    static func genres() -> [Int:Genre] {
        let data = defaults.data(forKey: genresKey)
        if let genres = NSKeyedUnarchiver.unarchiveObject(with: data!) as? [Int:Genre] {
            return genres
        }
        return [Int:Genre]()
    }
}
