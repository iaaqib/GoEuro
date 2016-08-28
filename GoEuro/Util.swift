//
//  Util.swift
//  GoEuro
//
//  Created by Muhammad Raza on 27/08/2016.
//  Copyright © 2016 Aaqib Hussain. All rights reserved.
//

import UIKit

@objc class Util : NSObject {


    
    static func animateCells(tableView: UITableView) {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for cell in cells {
            let cell: UITableViewCell = cell as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }


    static func showAlert(title:String , message : String, buttonTitle : String, sender: UIViewController, completion: (() -> Void)!){
    
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let okbutton = UIAlertAction(title: buttonTitle, style: .Default) { (alert) in
                completion()
            }
            let cancelButton = UIAlertAction(title: "Cancel",style: .Default, handler: nil)
            alert.addAction(okbutton)
            alert.addAction(cancelButton)
            sender.presentViewController(alert, animated: true, completion: nil)
            
        
        } else {
//
            let alert = UIAlertView()
                alert.delegate = sender
                alert.title = title
                alert.message = message

                alert.addButtonWithTitle("Cancel")
                alert.addButtonWithTitle(buttonTitle)
                alert.show()
            
            
        }
    
    }
    static func sortedData(array: NSMutableArray, valueKey: String) -> NSArray{
    

    
        
        let timeDescriptor = NSSortDescriptor(key: valueKey, ascending: true)
        let sortDescriptor = NSArray(object: timeDescriptor)
        let sortedArray : NSArray = array.sortedArrayUsingDescriptors(sortDescriptor as! [NSSortDescriptor])
        return sortedArray
    }
    static func showActionSheet(sender : UIViewController, completionForDepart: (() -> Void)!, completionForArrival: (() -> Void)!){
        
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: "Sort By", message: "Either Departure Time or Arrival Time", preferredStyle: .ActionSheet)
            let depart = UIAlertAction(title: "Departure Time", style: .Default) { (alert) in
                completionForDepart()
            }
            let arrival = UIAlertAction(title: "Arrival Time", style: .Default) { (alert) in
                completionForArrival()
            }
            
            let cancelButton = UIAlertAction(title: "Cancel",style: .Default, handler: nil)
            alert.addAction(depart)
            alert.addAction(arrival)
            alert.addAction(cancelButton)
            sender.presentViewController(alert, animated: true, completion: nil)
            
            
        } else {
//
            let alert = UIAlertView()
            alert.delegate = sender
            alert.title = "Sort By"
            alert.message = "Either Departure Time or Arrival Time"
            alert.addButtonWithTitle("Departure Time")
            alert.addButtonWithTitle("Arrival Time")
            alert.addButtonWithTitle("Cancel")
            alert.show()
            
            
            
        }
    
    
    }
    static func alertForOffers(sender : UIViewController){
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: "Sorry", message: "Offer details are not yet implemented!", preferredStyle: .Alert)
            let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
         
            alert.addAction(okButton)
            sender.presentViewController(alert, animated: true, completion: nil)
            
            
        } else {
            
            let alert = UIAlertView()
            alert.delegate = sender
            alert.title = "Sorry"
            alert.message = "Offer details are not yet implemented!"
            alert.addButtonWithTitle("OK")
            alert.show()
            
            
            
        }
    
    
    }

}