//
//  BaseViewController.swift
//  ReplicateFlicks
//
//  Created by monus on 2/12/17.
//  Copyright © 2017 Mufi. All rights reserved.
//

import UIKit
import ReachabilitySwift

class BaseViewController: UIViewController {

    let reachability = Reachability()!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async(execute: {
                let baseNav = self.navigationController as! BaseNavigationController
                baseNav.errorBar.isHidden = true
            })
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async(execute: {
                let baseNav = self.navigationController as! BaseNavigationController
                baseNav.errorBar.isHidden = false
            })
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
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
