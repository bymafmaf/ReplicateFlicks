//
//  MoviesViewController.swift
//  ReplicateFlicks
//
//  Created by monus on 31/01/2017.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import UIColor_Hex_Swift

class MoviesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    @IBOutlet weak var movieTableView: UITableView!
    var searchController: UISearchController?
    
    let baseUrl: String = "https://image.tmdb.org/t/p/w500"
    var endpoint: String!
    
    
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        retrieveInfo(nil)
        initializeRefreshControl()
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.sizeToFit()
        movieTableView.tableHeaderView = searchController?.searchBar
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let filteredData = filteredData {
            return filteredData.count
        } else{
            return 0
        }
    }
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            
            filteredData = searchText.isEmpty ? movies : movies?.filter({(aMovie: NSDictionary!) -> Bool in
                return (aMovie["title"] as! String).range(of: searchText, options: .caseInsensitive) != nil
            })
            
            movieTableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCellView
        
        let aMovie = filteredData![indexPath.row]
        
        cell.title.text = aMovie["title"] as! String
        cell.overview.text = aMovie["overview"] as! String
        
        if let posterPath = aMovie["poster_path"] as? String {
            let smallImageBaseUrl = "https://image.tmdb.org/t/p/w45"
            let smallImageRequest = URLRequest(url: URL(string: smallImageBaseUrl + posterPath)!)
            let largeImageRequest = URLRequest(url: URL(string: baseUrl + posterPath)!)
            
            cell.posterView.setImageWith(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = smallImage;
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        cell.posterView.alpha = 1.0
                        
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        cell.posterView.setImageWith(
                            largeImageRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                cell.posterView.image = largeImage;
                                
                        },
                            failure: { (request, response, error) -> Void in
                                // do something for the failure condition of the large image request
                                // possibly setting the ImageView's image to a default image
                        })
                    })
            },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            })
            
            
        }
        
        //cell.selectionStyle = .none
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor("#5D707F")
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func retrieveInfo(_ refreshControl: UIRefreshControl?){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    //print(dataDictionary)
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    self.filteredData = self.movies
                    self.movieTableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let refreshControl = refreshControl {
                        refreshControl.endRefreshing()
                    }
                }
            }
        }
        task.resume()
    }
    func initializeRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(retrieveInfo(_:)), for: UIControlEvents.valueChanged)
        
        movieTableView.addSubview(refreshControl)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let indexPath = movieTableView.indexPath(for: sender as! UITableViewCell)
        let oneMovie = filteredData![indexPath!.row]
        
        let detailVC = segue.destination as! DetailViewController
        
        detailVC.movieInfo = oneMovie
        
    }
}
