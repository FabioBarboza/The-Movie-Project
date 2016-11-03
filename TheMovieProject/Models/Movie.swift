//
//  Movie.swift
//  TheMovieProject
//
//  Created by Fabio Barboza on 03/11/16.
//  Copyright © 2016 Kobe. All rights reserved.
//

import Foundation

struct MovieConstants {
    static let backdropPath = "backdrop_path"
    static let genreIds = "genre_ids"
    static let objectId = "id"
    static let overview = "overview"
    static let popularity = "popularity"
    static let posterPath = "poster_path"
    static let releaseDate = "release_date"
    static let title = "title"
}

class Movie {
    
    let backdropPath: String
    let genreIds: Array<AnyObject>
    let objectId: Int
    let overview: String
    let popularity: Float
    let posterPath: String
    let releaseDate: String
    let title: String
    
    init(backdropPath: String, genreIds: Array<AnyObject>, objectId: Int, overview: String, popularity: Float, posterPath: String, releaseDate: String, title: String) {
        self.backdropPath = backdropPath
        self.genreIds = genreIds
        self.objectId = objectId
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
    }
    
    convenience init?(json: [String: AnyObject]) {
        guard let backdropPath = json[MovieConstants.backdropPath] as? String,
            let genreIds = json[MovieConstants.genreIds] as? [AnyObject],
            let objectId = json[MovieConstants.objectId] as? Int,
            let overview = json[MovieConstants.overview] as? String,
            let popularity = json[MovieConstants.popularity] as? Float,
            let posterPath = json[MovieConstants.posterPath] as? String,
            let releaseDate = json[MovieConstants.releaseDate] as? String,
            let title = json[MovieConstants.title] as? String
            else { return nil }
        self.init(backdropPath: backdropPath,
                  genreIds: genreIds,
                  objectId: objectId,
                  overview: overview,
                  popularity: popularity,
                  posterPath: posterPath,
                  releaseDate: releaseDate,
                  title: title)
    }
    
}
