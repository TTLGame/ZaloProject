//
//  ViewController.swift
//  ZaloProject
//
//  Created by geotech on 10/09/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    // user's data and API data
    var data = ReadAndFetchData()
    
    //Tools
    let queue = OperationQueue()
    var searchTimer: Timer?
    let viewSearchBar = UISearchController(searchResultsController: nil)
    func loadDataAndLoadView(){
        // load Data from API
        do {
            try data.loadData(APIUrl: "https://api.unsplash.com/photos?page=1")
        } catch DataError.failToUnwrapItems {
            print("Fail to resolve the optional data")
        }
        catch{
            print("Fail to load data")
        }
       
        //load View
        self.viewSearchBar.searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataAndLoadView()
       
        //viewSearchBar delegate
        viewSearchBar.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = self.viewSearchBar
        navigationItem.searchController?.searchBar.placeholder = "Search photos"
        navigationItem.title = "Gallery"
    }
}
