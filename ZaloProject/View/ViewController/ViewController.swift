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
    var isLoading = false
    var searchTimer: Timer?
    
    //save the search information
    var keyword = ""
    var type = 1 // demtermine whether to load default data or search data
    
    let viewSearchBar = UISearchController(searchResultsController: nil)
    
    //load more data when scrolling down
    func loadMoreData(){
        if (!isLoading){
            isLoading = true
            DispatchQueue.global().async {
                //delay to load data
                sleep(1)
                
                DispatchQueue.main.async {
                    if (self.type == 1 ){
                        self.loadData(type: 1, APIUrl: "https://api.unsplash.com/photos?page=")
                    }
                    else{
                        self.loadData(type:2, APIUrl: "https://api.unsplash.com/search/photos?query="+self.keyword+"&page=")
                    }
                    self.tableView.reloadData()
                    self.isLoading = false
                }
               
            }
        }
    }
    
    //load data
    func loadData(type:Int, APIUrl: String){
        // load Data from API
        do {
            try data.loadData(type: type, APIUrl: APIUrl)
        } catch DataError.failToUnwrapItems {
            print("Fail to resolve the optional data")
        }
        catch{
            print("Fail to load data")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //viewSearchBar delegate
        viewSearchBar.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = self.viewSearchBar
        navigationItem.searchController?.searchBar.placeholder = "Search photos"
        navigationItem.title = "Gallery"
        
        //load data and load view
        loadData(type:1, APIUrl: "https://api.unsplash.com/photos?page=")
        
        //load View
        self.viewSearchBar.searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.reloadData()
    }
}
