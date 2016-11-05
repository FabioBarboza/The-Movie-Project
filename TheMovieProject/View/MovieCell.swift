//
//  MovieCell.swift
//  TheMovieProject
//
//  Created by Fabio Barboza on 03/11/16.
//  Copyright © 2016 Kobe. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var popularity: UILabel!
    
    func set(movie: Movie) {
        title.text = movie.title.uppercased()
        releaseDate.text = movie.releaseDate
        popularity.text = String(format:"%0.1f", movie.popularity!)
        genre.text = movie.genres()
        poster.image = #imageLiteral(resourceName: "placeholder")
        
        UIImage.image(from: movie.posterPath!, response: { (image) in
            DispatchQueue.main.async {
                self.poster.image = image
            }
        })
    }

}
