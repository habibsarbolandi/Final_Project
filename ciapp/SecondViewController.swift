import UIKit
import CoreData


class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate{
    
    var clickedRow:Int?
    var allFavourites = [Business]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noFavouritesMsgLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tabBarController?.delegate = self
        
        //load all favourites from CoreData
        loadAllFavourites()
        if allFavourites.count == 0 {
            tableView.isHidden = true
        } else {
            noFavouritesMsgLabel.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(SecondViewController.actOnFavouritesChange), name: NSNotification.Name(notifKey), object: nil)
        print("Number of favourites " + String(allFavourites.count))
    }
    
    func actOnFavouritesChange() {
        allFavourites.removeAll()
        loadAllFavourites()
        tableView.reloadData()
        
        if (allFavourites.count == 0) {
            tableView.isHidden = true
            noFavouritesMsgLabel.isHidden = false
        } else {
            tableView.isHidden = false
            noFavouritesMsgLabel.isHidden = true
        }
    }
    
    func loadAllFavourites() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let data = try context.fetch(fetchRequest) as! [NSManagedObject]
            allFavourites = []
            
            for business in data {
                allFavourites.append(Business(id: business.value(forKey: "id") as! Int, name: business.value(forKey: "name") as! String, services: business.value(forKey: "services") as! String, location: business.value(forKey: "location") as! String, direction: business.value(forKey: "direction") as! String, workingHours: business.value(forKey: "workingHours") as! String, contact: business.value(forKey: "contact") as! String))
            }
        }
        catch {
            print("An error occured while loading all favourites")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: -Table View delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // 1 row per section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allFavourites.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let clearView = UIView()
        clearView.backgroundColor = UIColor.clear
        
        let cell:CustomFavouritesCell = self.tableView.dequeueReusableCell(withIdentifier: "favouritesCell") as! CustomFavouritesCell
        
        cell.nameLabel.text = self.allFavourites[indexPath.row].name
        cell.locationLabel.text = self.allFavourites[indexPath.row].location
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
        clickedRow = indexPath.row
        performSegue(withIdentifier: "seeFavouriteDetails", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destViewController = segue.destination as! BusinessDetailsController
        destViewController.business = allFavourites[clickedRow!]
        destViewController.id = allFavourites[clickedRow!].id
    }

}

