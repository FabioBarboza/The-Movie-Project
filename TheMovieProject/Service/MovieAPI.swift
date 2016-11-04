//
//  MovieAPI.swift
//  TheMovieProject
//
//  Created by Fabio Barboza on 02/11/16.
//  Copyright © 2016 Kobe. All rights reserved.
//

import Foundation
import Alamofire

typealias MOVIE_SUCCESS = ((_ data: [Movie]) -> Void)
typealias MOVIE_FAILURE = ((_ error: Error) -> Void)


struct MovieAPI {
    
    static func request(endpoint: MovieAPI.Endpoints, success: @escaping MOVIE_SUCCESS, failure: @escaping MOVIE_FAILURE) {
        
        Alamofire.request(endpoint.path, method: endpoint.method, parameters: endpoint.parameter)
            .validate()
            .responseJSON { (response: DataResponse<Any>) in
                if let err = response.result.error {
                    failure(err)
                } else {
                    if let resp = response.result.value as? [String:AnyObject],
                        let data = resp["results"] as? [[String:AnyObject]] {
                        var movies = [Movie]()
                        for values in data {
                            if let movie = Movie(json: values) {
                                movies.append(movie)
                            } else {
                                print(values)
                            }
                        }
                        success(movies)
                    }
                }
            }
    }
    
    enum Endpoints {
        
        case upcoming(page: Int, language: String)
        
        var movieURL: String {return AppSettings.baseURL + "movie/"}
        
        var method: Alamofire.HTTPMethod {
            switch self {
            case .upcoming:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .upcoming:
                return movieURL + "upcoming"
            }
        }
        
        var parameter: [String: AnyObject]? {
            switch self {
            case .upcoming(let page, let language):
                return ["page": page as AnyObject,
                        "language": language as AnyObject,
                        "api_key": AppSettings.apiKey as AnyObject]
            }
        }
    }
    
}
