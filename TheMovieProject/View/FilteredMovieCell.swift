//
//  FilteredMovieCell.swift
//  TheMovieProject
//
//  Created by Fabio Barboza on 05/11/16.
//  Copyright © 2016 Kobe. All rights reserved.
//

import UIKit

class FilteredMovieCell: UITableViewCell {
    @IBOutlet weak var backdrop: UIImageView!
    
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    func set(movie: Movie) {
        title.text = movie.title.uppercased()
        releaseDate.text = movie.releaseDate
        genre.text = movie.genres()
        backdrop.image = #imageLiteral(resourceName: "placeholder")
        
        UIImage.image(from: movie.backdropPath!, response: { (image) in
            DispatchQueue.main.async {
                self.backdrop.image = image
            }
        })
    }
    
}
