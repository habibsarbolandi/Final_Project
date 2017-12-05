//
//  BusinessDetailsController.swift
//  ciapp
//
//  Created by kwame on 11/5/17.
//  Copyright © 2017 iOS class. All rights reserved.
//

import UIKit
import CoreData
import AERecord

var notifKey = "com.ciapp.notifkey"

class BusinessDetailsController: UIViewController {
    var id = 0 //set id to some arbitrary num. will modified when user transitions to this
    //page
    var business:Business?
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessLocationLabel: UILabel!
    @IBOutlet weak var servicesDescrLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    
    func announceFavouritesChange() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifKey), object: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessNameLabel.text = business?.name
        servicesDescrLabel.text = business?.services
        businessLocationLabel.text =  (business?.location)!
        workingHoursLabel.text = business?.workingHours
        contactButton.setTitle(business?.contact, for: .normal)
        
        //Check if this business is in CoreData. If it is, change the title
        //on the addOrRemBusiness button from the default of "Add to 
        //Favourites" to "Remove from Favourites"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        fetchRequest.predicate = NSPredicate(format: "id == " + String(id))

        do{
            let records = try context.fetch(fetchRequest)
            if records.count > 0 {
                addOrRemBusinessButton.setTitle("Remove from favourites", for: .normal)
            }
        }
        catch {
            print("error ocurred while performing search request")
        }
    }
    
    
    @IBOutlet weak var addOrRemBusinessButton: UIButton!
    @IBAction func addOrRemoveBusinessFromFavourites(_ sender: Any) {
        let labelOnAddOrRemButton = addOrRemBusinessButton.title(for: .normal)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        if labelOnAddOrRemButton?.range(of:"Add") != nil  {
            //show activity indicator with text "Saving..."
            EZLoadingActivity.showWithDelay("Saving...", disableUI: false, seconds: 1)
            //save business details in CoreData
            //reference appDelegate so can work with CoreData
            
            let newFavourite = NSEntityDescription.insertNewObject(forEntityName: "Favourites", into: context)
            
            newFavourite.setValue(business?.id, forKey: "id" )
            newFavourite.setValue(business?.name, forKey: "name")
            newFavourite.setValue(business?.services, forKey: "services")
            newFavourite.setValue(business?.location, forKey: "location")
            newFavourite.setValue(business?.direction, forKey: "direction")
            newFavourite.setValue(business?.workingHours, forKey: "workingHours")
            newFavourite.setValue(business?.contact, forKey: "contact")
            
            do {
                try context.save()
                //change text in button that was clicked to save
                //this business
                addOrRemBusinessButton.setTitle("Remove from Favourites", for: .normal)
                
                //announce the change in favourites
                announceFavouritesChange()
            }
            catch {
                //stop activity indicator tell user that error occured
                //EZLoadingActivity.hide(false, animated: true)
            }
        } else {
            //title on button does not have "Add" in there so it is the
            //"Remove" button and so user intends to remove this business
            //from Favourites
            
            //show activity indicator with text "Saving..."
            EZLoadingActivity.showWithDelay("Deleting...", disableUI: false, seconds: 1)
            deleteFavourite(id: (business?.id)!)
            
            //change title on addOrRemBusiness button
            addOrRemBusinessButton.setTitle("Add to favourites", for: .normal)
            announceFavouritesChange()
        }

    }
    
    private func deleteFavourite(id: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        
        fetchRequest.predicate = NSPredicate(format: "id == " + String(id))
        
        do{
            let records = try context.fetch(fetchRequest)
            for business in records {
                context.delete(business as! NSManagedObject)
            }
            do {
                try context.save()
            } catch {print("could not save context")}
        }
        catch {
            print("deletion of business from favourites failed")
        }

    }
    
    @IBAction func callBusiness(_ sender: Any) {
        let contactNo = contactButton.titleLabel?.text!
        print(type(of: contactNo!))
        
        /*If statement below mainly from StackOverflow:
         https://stackoverflow.com/questions/27259824/calling-a-phone-number-in-swift
         TODO: unable to test phone call in simulator. Find someone with iPhone and try
         */
        
        if let url = URL(string: "tel://\(contactNo!)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        //hide activity indicator (if it's running)
        EZLoadingActivity.hide()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
