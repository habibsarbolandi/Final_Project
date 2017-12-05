import UIKit

//import the cocoa library "DropDown"
import DropDown
import CoreLocation
import CoreData

class FirstViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
	//instantiate the library
    let dropDown = DropDown()
    let locationManager = CLLocationManager()
    var previousSearches = [String]()
    var addressString: String = ""
    var currentLocation: String = ""
    
    @IBOutlet weak var searchQueryInput: UITextField!
    @IBOutlet weak var anc: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet var searchLabel: UILabel!
    
    /*This creates the table for previous searches*/
    @IBOutlet weak var table: UITableView!
    
    
    /*When user presses "change location", show a dropdown with
    list of areas to choose from (this approach to location may seem
    primitive but is the best choice for the intended market (Africa) where
    location based services are almost non-existent in most areas) */
    
    @IBAction func changeLocationPressed(_ sender: Any) {
        searchQueryInput.resignFirstResponder()
        
        // creates geocoder for changing the location to friendly stuff
        let geoCdr = CLGeocoder()
        
        // creates alert adress
        let alertAddress = UIAlertController(title: "Location", message: "Please type your address or zip code", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil)
        // confrom action that saves the users typed string into a placemerk and subsequently a location
        let confirmAddress = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: ({
            (_) in
            
            // saves the text written to the address string on the first view controller
            if let addressField = alertAddress.textFields?[0] {
                self.addressString = addressField.text!
            }
            // fail safe incase the string is empty
            if self.addressString != "" && self.addressString.count >= 5 {
                // changes the location string to placemarker
                geoCdr.geocodeAddressString(self.addressString, completionHandler: { (placemarks, error) in
                    let placemarks = placemarks
                    if placemarks?.first?.location != nil && placemarks?.first?.locality != nil && placemarks?.first?.postalCode != nil {
                        //let location = placemarks?.first?.location
                        self.currentLocation = (placemarks?.first?.locality)! + ", " + (placemarks?.first?.administrativeArea)!
                        // changes the text laberl on the screen to the placemark info
                        self.locationLabel.text = (placemarks?.first?.locality)! + ", " + (placemarks?.first?.postalCode)!
                    }
                })
            }
            
        }))
        
        // adds the text field for input to address alert
        alertAddress.addTextField(configurationHandler: ({
            (UITextField) in
            UITextField.placeholder = "Zip Code"
        }))
        // assigns the action and presents the alert
        alertAddress.addAction(confirmAddress)
        alertAddress.addAction(cancelAction)
        self.present(alertAddress, animated: true, completion: nil)
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchQueryInput.delegate = self
        locationManager.delegate = self
        table.dataSource = self
        table.delegate = self
        
        // accuracy of location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // requestion location access when app is in foreground
        locationManager.requestWhenInUseAuthorization()
        
        // starts updating location
        locationManager.startUpdatingLocation()
        
        // checks of location accesss is granted
        if CLLocationManager.authorizationStatus() == .denied {
            
            // alert for access
            let alertLocation = UIAlertController(title: "Location Access", message: "Without location access, you will need to personally type your location for searching. Select Settings to enable location access.", preferredStyle: .alert)
            // action for settings
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            
            let manualLocation = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: ({
                (_) in
                
                let geoCdr = CLGeocoder()
                let alertAddress = UIAlertController(title: "Location", message: "Please type your zip code", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil)
                
                let confirmAddress = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: ({
                    (_) in
                    
                    if let addressField = alertAddress.textFields?[0] {
                        self.addressString = addressField.text!
                    }
                    if self.addressString != "" && self.addressString.count == 5 {
                        geoCdr.geocodeAddressString(self.addressString, completionHandler: { (placemarks, error) in
                            let placemarks = placemarks
                            if placemarks?.first?.location != nil && placemarks?.first?.locality != nil && placemarks?.first?.postalCode != nil{
                                //let location = placemarks?.first?.location
                                self.currentLocation = (placemarks?.first?.locality)! + ", " + (placemarks?.first?.administrativeArea)!
                                // changes the text laberl on the screen to the placemark info
                                self.locationLabel.text = (placemarks?.first?.locality)! + ", " + (placemarks?.first?.postalCode)!
                            } else {
                                let alertNoAddress = UIAlertController(title: "Zip Code", message: "Your entry is invalid, please try again", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil)
                                alertNoAddress.addAction(alertAction)
                                self.present(alertNoAddress, animated: true, completion: nil)
                            }
                        })
                    } else {
                        let alertNoAddress = UIAlertController(title: "Zip Code", message: "Your entry is invalid, please try again", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil)
                        alertNoAddress.addAction(alertAction)
                        self.present(alertNoAddress, animated: true, completion: nil)
                    }
                }))
                
                alertAddress.addTextField(configurationHandler: ({
                    (UITextField) in
                    UITextField.placeholder = "Address, City, State, Zip"
                }))
                self.present(alertAddress, animated: true, completion: nil)
                alertAddress.addAction(confirmAddress)
                alertAddress.addAction(cancelAction)
            }))
            
            alertLocation.addAction(settingsAction)
            alertLocation.addAction(manualLocation)
            
            self.present(alertLocation, animated: true, completion: nil)
        }
        fetchPreviousSearches()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[0]
        //print(currentLocation)
        
        let geoCdr = CLGeocoder()
        
        // gets location in address mode
        geoCdr.reverseGeocodeLocation(currentLocation, completionHandler: {placemarks,error in
            var placemark:CLPlacemark!
            
            var addressZip: String = ""
            var addressCity: String = ""
            
            if error == nil && placemarks!.count > 0 {
                placemark = placemarks![0] as CLPlacemark
                if placemark.postalCode != nil && placemark.locality != nil {
                    addressZip = placemark.postalCode!
                    addressCity = placemark.locality!
                    self.locationLabel.text = addressCity + ", " + addressZip
                    //print(placemark.subAdministrativeArea)
                    //print(placemark.postalCode)
                }
            }
            
        })
        
    }
    
    //Ensure that textbox is not blank then transition to SearchResults screen
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchQueryInput.resignFirstResponder()
    
        if searchQueryInput.text != ""{
            
            previousSearches.append(searchQueryInput.text!)
            saveItem()
            self.table.reloadData()
            table.isHidden = false
            searchLabel.isHidden = true
            performSegue(withIdentifier: "SeeSearchResults", sender: self)
            //searchQueryInput.text = ""
        }
    }
    
    func saveItem() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newSearch = NSEntityDescription.insertNewObject(forEntityName: "PreviousSearches", into: context)
        newSearch.setValue(previousSearches.last!, forKey: "search")
        print("saving to core")
        
        do {
            try context.save()
        }
        catch {
            print("error")
        }
    }
    
    func fetchPreviousSearches() {
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PreviousSearches")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let data = try context.fetch(fetchRequest) as! [NSManagedObject]
            previousSearches = []
            
            for search in data {
                previousSearches.append(search.value(forKey: "search") as! String)
            }
        }
        catch {
            print("error")
        }
        if previousSearches.count == 0 {
            table.isHidden = true
            searchLabel.isHidden = false
        } else {
            table.isHidden = false
            searchLabel.isHidden = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        let searchedTerm = previousSearches.reversed()[indexPath.row]
        cell.textLabel?.text = searchedTerm
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.textAlignment = .center
        
        return cell
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //get text inside cell
        let cell = tableView.cellForRow(at: indexPath)
        searchQueryInput.insertText((cell?.textLabel?.text!)!)
        performSegue(withIdentifier: "SeeSearchResults", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*Send the user-inputted searchQuery and location to SearchResultsController before
    segue. SearchResultsController will use this data to make a requst to
    the backend server which will respond with the appropriate results ranked
    based on proximity to the user-selected location 
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController = segue.destination as! SearchResultsController
        let defaultLocation = "Dichemso"
        
        if dropDown.selectedItem != nil {
            DestViewController.location = dropDown.selectedItem!
        } else {
            DestViewController.location = defaultLocation
        }
        
        DestViewController.currentLocation = currentLocation
        DestViewController.searchQuery = searchQueryInput.text!
        searchQueryInput.text = ""
    }
    
    //Let text input lose focus when user touches somewhere outside it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchQueryInput.resignFirstResponder()
    }
    
    //When user presses return key, perform segue to transition to SearchResults view
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        previousSearches.append(searchQueryInput.text!)
        saveItem()
        self.table.reloadData()
        table.isHidden = false
        searchLabel.isHidden = true
        
        performSegue(withIdentifier: "SeeSearchResults", sender: self)
        
        
        //print(previousSearches)
        //searchQueryInput.text = ""
        return true
    }
}



