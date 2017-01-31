//
//  MovieCellView.swift
//  ReplicateFlicks
//
//  Created by monus on 31/01/2017.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit

class MovieCellView: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var overview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
