//
//  NetworkController.swift
//  ReplicateFlicks
//
//  Created by monus on 31/01/2017.
//  Copyright © 2017 Mufi. All rights reserved.
//

import Alamofire

class NetworkController {
    
    let instance: NetworkController = NetworkController()
    
    func sharedInstance() -> NetworkController{
        
        return instance
    }
    
}
