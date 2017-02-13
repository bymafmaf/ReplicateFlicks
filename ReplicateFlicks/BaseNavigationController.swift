//
//  BaseNavigationController.swift
//  ReplicateFlicks
//
//  Created by monus on 2/12/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    let errorBar = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        errorBar.backgroundColor = UIColor.darkGray
        errorBar.frame = CGRect(x: 0, y: self.navigationBar.frame.height, width: self.view.frame.width, height: 20)
        errorBar.isHidden = true
        
        let errorText = UILabel()
        errorText.textColor = UIColor.white
        errorText.text = "Network Error"
        errorText.textAlignment = NSTextAlignment.center
        errorText.font = UIFont.boldSystemFont(ofSize: 13)
        errorText.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
        errorBar.addSubview(errorText)
        
        
        self.navigationBar.addSubview(errorBar)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
