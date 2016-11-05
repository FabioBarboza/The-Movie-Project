//
//  MovieDetailController.swift
//  TheMovieProject
//
//  Created by Fabio Barboza on 04/11/16.
//  Copyright © 2016 Kobe. All rights reserved.
//

import UIKit

class MovieDetailController: UIViewController {
    
    // MARK: - CONSTANTS
    let navTitle = "Movie"
    let movieDetailsCell = "MovieDetailsCell"
    let movieOverviewCell = "MovieOverviewCell"
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    @IBOutlet weak var movieBackdrop: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    var movie: Movie!

    //MARK: - VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = navTitle
        movieDetails()
    }
    
    //MARK: - DATA
    func movieDetails() {
        self.movieTitle.text = movie.title.uppercased()
        UIImage.image(from: movie.backdropPath!, response: { (image) in
            DispatchQueue.main.async {
                self.movieBackdrop.image = image
            }
        })
    }
    
}

extension MovieDetailController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension MovieDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let detailCell = tableView.dequeueReusableCell(withIdentifier: movieDetailsCell, for: indexPath) as? MovieDetailsCell {
                
                detailCell.releaseDate.text = movie.releaseDate
                detailCell.popularity.text = String(format:"%0.1f", movie.popularity!)
                detailCell.genres.text = movie.genres()
                
                UIImage.image(from: movie.posterPath!, response: { (image) in
                    DispatchQueue.main.async {
                        detailCell.poster.image = image
                    }
                })
                return detailCell
            }
        } else {
            if let overviewCell = tableView.dequeueReusableCell(withIdentifier: movieOverviewCell, for: indexPath) as? MovieOverviewCell {
                overviewCell.overview.text = movie.overview
                return overviewCell
            }
        }
        return UITableViewCell()
    }
    
}
