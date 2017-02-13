//
//  DetailViewController.swift
//  ReplicateFlicks
//
//  Created by monus on 2/7/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController {

    @IBOutlet weak var imagePoster: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var movieInfo: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        titleLabel.text = movieInfo!["title"] as! String
        detailLabel.text = movieInfo!["overview"] as! String
        
        detailLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        
        if let posterPath = movieInfo["poster_path"] as? String {
            let photoUrl = URL(string: baseUrl + posterPath)
            imagePoster.setImageWith(photoUrl!)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: infoView.frame.origin.y + infoView.frame.height)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
 

}
