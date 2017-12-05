//
//  CommonTestsVC.swift
//  ciapp
//
//  Created by Cameron Ghods on 11/29/17.
//  Copyright © 2017 iOS class. All rights reserved.
//

import UIKit

class CommonTestsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableview1: UITableView!
    @IBOutlet weak var tableview2: UITableView!
  
    let tests : [String] = ["Blood","Imaging","Other"]
    
    let bloodTests : [String] = ["Antinuclear Antibody Test","Hemoglobin Test","CA 125","Liver Blood Test", "Complete Blood Count","Thyroid Blood Test","Creatine Blood Test","Electrolytes Test"]
    let imagingTests : [String] = ["CAT Scan","MRI Scan","Ultrasound","X-ray"]
    let otherTests : [String] = ["Colonoscopy","Pap Smear","Coronary Artery Bypass Graft (CABG)","Tuberculosis Skin Test"]
    
    var testReference : String = "Blood"
    var chosenTest: String = ""
    
    let cellIdentifier : String = "cell"
    
    var numberOfTests : Int = 0
    var testsInGroup : Int = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview1.delegate = self
        tableview2.delegate = self
        tableview1.dataSource = self
        tableview2.dataSource = self
    
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.tag == 1)
        {
            numberOfTests = tests.count
            return numberOfTests
        }
            
        else if (tableView.tag == 2)
        {
            if (testReference == "Blood")
            {
                testsInGroup = bloodTests.count
            }
            else if (testReference == "Imaging")
            {
                testsInGroup = imagingTests.count
            }
            else if (testReference == "Other")
            {
                testsInGroup = otherTests.count
            }
        return testsInGroup
        }
        else
        {
        return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        
        if (tableView.tag == 1)
        {
            cell.textLabel?.text = tests[indexPath.row]
            cell.textLabel?.textColor = UIColor.white
        }
        else if (tableView.tag == 2)
        {
            if (testReference == "Blood")
            {
                cell.textLabel?.text = bloodTests[indexPath.row]
            }
            else if (testReference == "Imaging")
            {
                cell.textLabel?.text = imagingTests[indexPath.row]
            }
            else if (testReference == "Other")
            {
                cell.textLabel?.text = otherTests[indexPath.row]
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.tag == 1)
        {
            testReference = tests[indexPath.row]
        }
        tableview2.reloadData()
        if (tableView.tag == 2)
        {
            if (testReference == "Blood")
            {
                chosenTest = bloodTests[indexPath.row]
                performSegue(withIdentifier: "identifier", sender: self)
            }
            else if (testReference == "Imaging")
            {
               chosenTest = imagingTests[indexPath.row]
                performSegue(withIdentifier: "identifier", sender: self)
            }
            else if (testReference == "Other")
            {
                chosenTest = otherTests[indexPath.row]
                performSegue(withIdentifier: "identifier", sender: self)
            }
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destViewController = segue.destination as! SearchResultsController
        destViewController.searchQuery = chosenTest
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
