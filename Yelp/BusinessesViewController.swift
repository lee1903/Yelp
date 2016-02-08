//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredBusinesses: [Business]!
    var businesses: [Business]!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        navItem.titleView = searchBar
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            self.filteredBusinesses = self.businesses
            
            self.tableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBusinesses != nil {
            return filteredBusinesses!.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = filteredBusinesses[indexPath.row]
        
        return cell
    }
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            filteredBusinesses = businesses
//        } else {
//            filteredBusinesses = businesses!.filter({(dataItem: Business) -> Bool in
//                let name = dataItem.name!
//                print(name)
//                if name.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
//                    return true
//                } else {
//                    return false
//                }
//            })
//        }
//        
//        tableView.reloadData()
//    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        Business.searchWithTerm(searchBar.text!, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if businesses != nil{
                self.businesses = businesses
                self.filteredBusinesses = self.businesses
            }
            
            self.tableView.reloadData()
        })
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        navItem.titleView?.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
