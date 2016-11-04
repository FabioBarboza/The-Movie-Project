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
    let movieDetailSegue = "MovieDetailSegue"
    var movies = [Movie]()
    var nextPage = 2
    var isLoading = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = CGFloat(estimatedRowHeight)
            
            let refresh = UIRefreshControl()
            tableView.addSubview(refresh)
            tableView.refreshControl = refresh
            refresh.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = navTitle
        refreshData()
    }
    
    //MARK: - Data
    
    func refreshData() {
        self.movies = [Movie]()
        self.nextPage = 2
        upgoingMovies(page:1)
    }
    
    func upgoingMovies(page: Int) {
        if isLoading == true {return}
        
        self.activityIndicator.startAnimating()
        isLoading = true
        self.tableView.refreshControl?.beginRefreshing()
        MovieAPI.request(endpoint: .upcoming(page: page, language: AppSettings.language), success: { data in
            if data.count == 0 {
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.movies.append(contentsOf: data)
            if page == 1 {
                self.tableView.reloadData()
            } else {
                self.tableView.beginUpdates()
                let currentRowCount = self.tableView.numberOfRows(inSection: 0)
                var indexPaths = [IndexPath]()
                for i in currentRowCount..<self.movies.count {
                    indexPaths.append(IndexPath(item: i, section: 0))
                }
                self.tableView.insertRows(at: indexPaths, with: .none)
                self.tableView.endUpdates()
            }
            self.nextPage += 1
            self.tableView.refreshControl?.endRefreshing()
            self.isLoading = false
            
            print(self.movies.count)
            
            }, failure: { error in
                print(error)
                self.tableView.refreshControl?.endRefreshing()
                self.activityIndicator.stopAnimating()
        })
    }
    
    //MARK: - Tableview
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: movieCellId, for: indexPath) as? MovieCell {
            
            let movie = movies[indexPath.row]
            cell.title.text = movie.title?.uppercased()
            cell.releaseDate.text = movie.releaseDate
            cell.popularity.text = String(format:"%0.1f", movie.popularity!)
            cell.genre.text = movie.genres()
            cell.poster.image = #imageLiteral(resourceName: "placeholder")
            
            UIImage.image(from: movie.posterPath!, response: { (image) in
                DispatchQueue.main.async {
                    cell.poster.image = image
                }
            })
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: movieDetailSegue, sender: indexPath)
    }
    
    //MARK: - Scrollview
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maxOffset - currentOffset <= 5.0  &&
            maxOffset - currentOffset >= 0.0 {
            self.upgoingMovies(page: self.nextPage)
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == movieDetailSegue {
            let movieDetail = segue.destination as? MovieDetailController
            let indexPath = sender as? IndexPath
            movieDetail?.movie = movies[(indexPath?.row)!]
        }
    }
}
