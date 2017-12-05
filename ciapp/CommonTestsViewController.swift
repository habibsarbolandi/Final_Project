//
//  CommonTestsViewController.swift
//  ciapp
//
//  Created by prince on 11/27/17.
//  Copyright © 2017 iOS class. All rights reserved.
//

import UIKit

class CommonTestsViewController: UIViewController {

    @IBAction func trans(_ sender: Any) {
        performSegue(withIdentifier: "SeeCommonTestsResults", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController = segue.destination as! SearchResultsController
        let defaultLocation = "Dichemso"
        
        DestViewController.location = defaultLocation
        
        
        DestViewController.searchQuery = "lab tests"
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
