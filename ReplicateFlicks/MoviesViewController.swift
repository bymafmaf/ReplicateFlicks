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

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var movieTableView: UITableView!
    
    let baseUrl: String = "https://image.tmdb.org/t/p/w500"
    
    var movies: [NSDictionary]?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movies = movies {
            return movies.count
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCellView
        
        let aMovie = movies![indexPath.row]
        
        cell.title.text = aMovie["title"] as! String
        cell.overview.text = aMovie["overview"] as! String
        let photoUrl = URL(string: baseUrl + (aMovie["poster_path"] as! String))
        
        cell.posterView.setImageWith(photoUrl!)
        
        return cell
    }
    
    func retrieveInfo(_ refreshControl: UIRefreshControl?){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.movies = dataDictionary["results"] as! [NSDictionary]
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
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        retrieveInfo(nil)
        initializeRefreshControl()
        
        
        
    }
}
