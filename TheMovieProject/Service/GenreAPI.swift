//
//  GenreAPI.swift
//  TheMovieProject
//
//  Created by Fabio Barboza on 03/11/16.
//  Copyright © 2016 Kobe. All rights reserved.
//

import Foundation
import Alamofire

typealias GENRE_SUCCESS = ((_ data: [Int:Genre]) -> Void)
typealias GENRE_FAILURE = ((_ data: Error) -> Void)

struct GenreAPI {
    
    static func request(endpoint: GenreAPI.Endpoints, success: @escaping GENRE_SUCCESS, failure: @escaping GENRE_FAILURE) {
        
        Alamofire.request(endpoint.path, method: endpoint.method, parameters: endpoint.parameter)
            .validate()
            .responseJSON { (response: DataResponse<Any>) in
                if let err = response.result.error {
                    failure(err)
                } else {
                    if let resp = response.result.value as? [String:AnyObject],
                        let data = resp["genres"] as? [[String:AnyObject]] {
                        var genres = [Int:Genre]()
                        for values in data {
                            if let genre = Genre(json: values) {
                                genres[genre.objectId] = genre
                            }
                        }
                        success(genres)
                    }
                }
        }
    }
    
    enum Endpoints {
        
        case movieList(language: String)
        
        var genreURL: String {return AppSettings.baseURL + "genre/"}
        
        var method: Alamofire.HTTPMethod {
            switch self {
            case .movieList:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .movieList:
                return genreURL + "movie/list"
            }
        }
        
        var parameter: [String: AnyObject]? {
            switch self {
            case .movieList(let language):
                return ["language": language as AnyObject,
                "api_key": AppSettings.apiKey as AnyObject]
            }
        }
    }
}
