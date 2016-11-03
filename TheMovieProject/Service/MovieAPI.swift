//
//  MovieAPI.swift
//  TheMovieProject
//
//  Created by Fabio Barboza on 02/11/16.
//  Copyright © 2016 Kobe. All rights reserved.
//

import Foundation

struct MovieAPI {
    
    enum Endpoints {
        case upcoming(page: Int, language: String)
        
        var baseURL: String {return "https://api.themoviedb.org/3/movies/"}
        var apiKey: String {return "1f54bd990f1cdfb230adb312546d765d"}
        
        var method: String {
            switch self {
            case .upcoming:
                return "GET"
            }
        }
        
        var path: String {
            switch self {
            case .upcoming:
                return baseURL + "upcoming/"
            }
        }
        
        var parameter: [String:AnyObject]? {
            switch self {
            case .upcoming(let page, let language):
                return ["page": page as AnyObject, "language": language as AnyObject, "api_key": apiKey as AnyObject]
            }
        }
    }
}
