//
//  MoviesController.swift
//  TheMovieProject
//
//  Created by Fabio Barboza on 03/11/16.
//  Copyright © 2016 Kobe. All rights reserved.
//

import UIKit

class MoviesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let navTitle = "Upcoming"
    let estimatedRowHeight = 322.0
    let movieCellId = "MovieCell"
    
    var movies = [Movie]()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = CGFloat(estimatedRowHeight)
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = navTitle
        
        MovieAPI.request(endpoint: .upcoming(page: 1, language: "en-US"), success: { data in
            print(data)
            self.movies.removeAll()
            self.movies.append(contentsOf: data)
            self.tableView.reloadData()
            
            }, failure: { error in
                print(error)
        })
        
        GenreAPI.request(endpoint: .movieList(language: "en-US"), success: { (data) in
            print(data)
            
        }) { (error) in
            print(error)
        }
        
    }
    
    //MARK: - Tableview
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: movieCellId, for: indexPath) as? MovieCell {
            
            let movie = movies[indexPath.row]
            cell.title.text = movie.title
            
            UIImage.image(from: movie.posterPath, response: { (image) in
                DispatchQueue.main.async {
                    cell.poster.image = image
                }
            })
            
            return cell
        } else {
            return UITableViewCell.init()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
