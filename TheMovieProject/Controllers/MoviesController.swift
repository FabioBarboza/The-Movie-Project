//
//  MoviesController.swift
//  TheMovieProject
//
//  Created by Fabio Barboza on 05/11/16.
//  Copyright © 2016 Kobe. All rights reserved.
//

import UIKit

struct MoviesControllerConstants {
    
    static let navTitle = "Upcoming"
    static let estimatedRowHeight = 322.0
    static let movieCellId = "MovieCell"
    static let filteredCellId = "FilteredCell"
    static let blankCellId = "BlankCell"
    static let movieDetailSegue = "MovieDetailSegue"
    static let errorConnectionMessage = "Could not connection to the sever. Try again later"
    static let errorConnectionTitle = "Error Connection"
    
}

class MoviesController: UITableViewController {
    
    // MARK: - CONSTANTS
    let searchController = UISearchController(searchResultsController: nil)
    
    var movies = [Movie]()
    var filteredMovies = [Movie]()
    var nextPage = 2
    var isLoading = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = CGFloat(MoviesControllerConstants.estimatedRowHeight)
        self.title = MoviesControllerConstants.navTitle
        setSearchBar()
        setRefreshControl()
        refreshData()
    }
    
    func setSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.barStyle = UIBarStyle.blackTranslucent
        tableView.tableHeaderView = searchController.searchBar
        tableView.backgroundView = UIView()
    }
    
    func setRefreshControl() {
        let refresh = UIRefreshControl()
        tableView.addSubview(refresh)
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
    }
    
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
            self.activityIndicator.stopAnimating()
            self.isLoading = false
            
            }, failure: { error in
                let alertController = UIAlertController(title: MoviesControllerConstants.errorConnectionTitle,
                                                        message: MoviesControllerConstants.errorConnectionMessage,
                                                        preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)

                self.isLoading = false
                self.tableView.refreshControl?.endRefreshing()
                self.activityIndicator.stopAnimating()
        })
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MoviesControllerConstants.movieDetailSegue {
            let movieDetail = segue.destination as? MovieDetailController
            if let indexPath = sender as? IndexPath {
                let movie: Movie
                if searchController.isActive && searchController.searchBar.text != "" {
                    movie = filteredMovies[indexPath.row]
                } else {
                    movie = movies[indexPath.row]
                }
                movieDetail?.movie = movie
            }
        }
    }
}

extension MoviesController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredMovies = movies.filter { movie in
            return movie.title.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
}


// MARK: - UITABLEVIEW DELEGATE
extension MoviesController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: MoviesControllerConstants.movieDetailSegue, sender: indexPath)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchController.isActive == false {
            let currentOffset = scrollView.contentOffset.y
            let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if maxOffset - currentOffset <= 5.0  &&
                maxOffset - currentOffset >= 0.0 {
                self.upgoingMovies(page: self.nextPage)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            if filteredMovies.count == 0 {
                return 1
            }
            return filteredMovies.count
        }
        return movies.count
    }
    
}

// MARK: - UITABLEVIEW DATASOURCE
extension MoviesController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie: Movie
        if searchController.isActive && searchController.searchBar.text != "" {
            if filteredMovies.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: MoviesControllerConstants.blankCellId, for: indexPath)
                return cell
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: MoviesControllerConstants.filteredCellId, for: indexPath) as? FilteredMovieCell {
                movie = filteredMovies[indexPath.row]
                cell.set(movie: movie)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: MoviesControllerConstants.movieCellId, for: indexPath) as? MovieCell {
                movie = movies[indexPath.row]
                cell.set(movie: movie)
                return cell
            }
        }
        return UITableViewCell()
    }

}
