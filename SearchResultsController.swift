//
//  SearchResultsController.swift
//  ciapp
//
//  Created by kwame on 11/4/17.
//  Copyright © 2017 iOS class. All rights reserved.
//

import UIKit
import CoreLocation

class SearchResultsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Assume these are all the businesses on the platform
    var currentLocation: String = ""
    var data = [
        Business(id: 1, name: "Sanora Labs", services: "Antinuclear Antibody Test, Hemoglobin Test, CA 125, CAT Scan, Liver Blood Tests, Colonoscopy, MRI Scan, Pap Smear, Complete Blood Count, Pap Smear, Coronary Artery Bypass Graft (CABG), Thyroid Blood Tests, Creatinine Blood Test, Tuberculosis Skin Test (PPD Skin Test), Electrolytes Test, Ultrasound", location: "Phoenix, AZ", direction: "Behind the secondary school", workingHours: "Monday - Friday (8am - 6pm)", contact: "4807034243"),
        
        Business(id: 2, name: "Quest International", services: "Antinuclear Antibody Test, Hemoglobin Test, CA 125, CAT Scan, Liver Blood Tests, Colonoscopy, MRI Scan", location: "Tempe, AZ", direction: "Behind the post office", workingHours: "Monday - Friday (8am - 6pm)", contact: "4807034243"),
        
        Business(id: 3, name: "HonorHealth", services: "Tuberculosis Skin Test (PPD Skin Test), Electrolytes Test, Ultrasound", location: "Flagstaff, AZ", direction: "Behind the catholic church ", workingHours: "Monday - Sunday (8am - 2pm)", contact: "4807034243"),
        
        Business(id: 4, name: "Private Care Testing Center", services: "Antinuclear Antibody Test, Hemoglobin Test, CA 125, CAT Scan, Liver Blood Tests, Colonoscopy, Creatinine Blood Test", location: "Tuscon, AZ", direction: "Behind the mosque", workingHours: "Monday - Friday (8am - 9pm)", contact: "4807034243"),
        
        Business(id: 5, name: "Insight Imaging", services: "CAT Scan, MRI Scan, Ultrasound", location: "Phoenix, AZ", direction: "Corner of Camelback and 22nd", workingHours: "Monday - Friday (8am - 8pm)", contact: "6029540954"),
        
        Business(id: 6, name: "LabCorp", services: "Antinuclear Antibody Test, Hemoglobin Test, Electrolytes Test, CA 125, Liver Blood Tests, MRI Scan", location: "Tempe, AZ", direction: "Corner of Southern and Countr Club way", workingHours: "Monday - Friday (8am - 6pm)", contact: "4804914161"),
        
        Business(id: 7, name: "Sonora Quest Laboratories", services: "Antinuclear Antibody Test, Hemoglobin Test, Liver Blood Tests, Coronary Artery Bypass Graft (CAPG), CA 125, Electrolytes Test, Creatine Blood Test, Tuberculosis Skin Test (PDD Skin Test)", location: "Tempe, AZ", direction: "Corner of Mill ave. and Washington St.", workingHours: "Monday - Friday (7am - 4pm)", contact: "6026855960"),
        
        Business(id: 8, name: "ARCpoint Labs of Tempe", services: "Hemoglobin Test, CA 125, Liver Blood Tests, Electrolytes Test, Creatine Blood Test", location: "Tempe, AZ", direction: "On McClinktock Rd.", workingHours: "Monday - Friday (8am - 5pm)", contact: "6027532901"),
        
        Business(id: 9, name: "Central Clinical Labs", services: "Antinuclear Antibody Test, Hemoglobin Test, Liver Blood Tests, Coronary Artery Bypass Graft (CAPG), CA 125, Electrolytes Test, Creatine Blood Test, Tuberculosis Skin Test (PDD Skin Test), Electrolytes Test, Complete Blood Count, Thyroid blood Test, ", location: "Phoenix, AZ", direction: "Off of University", workingHours: "Monday - Friday (8am - 11pm)", contact: "8449901334"),
        
        Business(id: 10, name: "Any Lab Test Now", services: "Hemoglobin Test, CA 125, Liver Blood Tests, Electrolytes Test, Creatine Blood Test, Antinuclear Antibody Test, Thyroid Blood Test, Complete Blood Count", location: "Phoenix, AZ", direction: "On Thomas Rd.", workingHours: "Monday - Friday (8am - 6pm)", contact: "6029550240"),
        
        Business(id: 11, name: "Lab Express Inc.", services: "Antinuclear Antibody Test, Complete Blood Count, Electrolytes Test, Thyroid Blood Test", location: "Mesa, AZ", direction: "Corner of Baseline and Extension", workingHours: "Monday - Friday (7am - 8pm)", contact: "6022739000"),
        
        Business(id: 12, name: "EVDI Medical Imaging", services: "CAT Scan, MRI Scan, Ultrasound, X-ray", location: "Mesa, AZ", direction: "On McClinktock Rd.", workingHours: "Monday - Friday (7am - 5pm)", contact: "4804569000"),
        
        Business(id: 13, name: "Scottsdale Medical Imaging", services: "CAT Scan, MRI Scan, Ultrasound, X-ray", location: "Scottsdale, AZ", direction: "Corner of Scottsdale and Osborn", workingHours: "Monday - Friday (8am - 5pm)", contact: "4804255000"),
        
        Business(id: 14, name: "AZ-Tech Radiology", services: "CAT Scan, MRI Scan, Ultrasound, X-ray", location: "Tempe, AZ", direction: "Southern and Loop 101", workingHours: "Monday - Friday (8am - 5pm)", contact: "4808202021"),
        
        Business(id: 15, name: "SimonMed Imaging", services: "CAT Scan, MRI Scan, Ultrasound, X-ray", location: "Phoenix, AZ", direction: "7th st. and I-10", workingHours: "Monday - Friday (8am - 5pm)", contact: "4802530000"),
        ]
    
    //assume has loaded data from server
    var loadedDataFromServer = true
    
    var searchQuery = String()
    var location = String()
    var clickedRow = Int()
    var searchController : UISearchController!
    var filteredData = [Business]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noOfResultsLabel: UILabel!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //self.searchController.searchResultsUpdater = self
        //self.searchController = UISearchController(SearchResultsController: self.tableView)
        
        //Count and display message about no. of search results
        updateSearchResults()
        if loadedDataFromServer {
            if data.count == 0 {
                noOfResultsLabel.text = "Sorry, no results found for \"" + searchQuery + "\""
            }
            else {
                self.title = String(filteredData.count) + " result(s)"
            }
        }
    }
    
    func updateSearchResults() {
        //filter through the data
        self.filteredData = self.self.data.filter { (data: Business) -> Bool in
            if data.services.localizedCaseInsensitiveContains(searchQuery) {
                return true
            } else {
                return false
            }
        }
        self.tableView.reloadData()
        //print(self.filteredData)
    }

    override func viewWillDisappear(_ animated: Bool) {
        EZLoadingActivity.hide()
    }
    
    //MARK: -Table View delegate methods
    
    //using sections instead of rows so that can put spacing between items
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filteredData.count
    }
    
    
    // 1 row per section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //set height of header in each section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let clearView = UIView()
        clearView.backgroundColor = UIColor.clear
        
        let cell:MyCustomCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! MyCustomCell
        
        //call search/ranking method to rank businesses based
        //on their proximity to the user-selected location
        let rankedBusinesses = simpleRanking(location: currentLocation)
        
        cell.businessNameLabel.text = rankedBusinesses[indexPath.section].name
        cell.businessLocationLabel.text = rankedBusinesses[indexPath.section].location
        cell.servicesDescLabel.text = rankedBusinesses[indexPath.section].services
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 3
        cell.selectedBackgroundView = clearView
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //cannot pass indexPath.row to "prepare for segue" method though it needs it so
        //save it in the clickedRow variable (at beginning of class) which "prepare for segue" method has
        //access to
        clickedRow = indexPath.section
        performSegue(withIdentifier: "seeBusinessDetails", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destViewController = segue.destination as! BusinessDetailsController
        destViewController.business = data[clickedRow]
        destViewController.id = data[clickedRow].id
    }
 
}

extension SearchResultsController {
    /*A very basic function that simulates taking the user-selected location into account in the ranking of results. Businesses in the same area as user will be
     shown first*/
    func simpleRanking(location: String) -> [Business] {
        var sameLocation:[Business] = []
        var otherLocations:[Business] = []
        
        //sort businesses into those in same location and those in other locations from user
        for business in filteredData {
            if business.location == location{
                sameLocation.append(business)
            } else {
                otherLocations.append(business)
            }
        }
        
        //merge otherLocations array to end of sameLocation array
        let new = sameLocation + otherLocations
        return new
    }
}
