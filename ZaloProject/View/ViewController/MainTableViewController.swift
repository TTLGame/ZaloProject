//
//  MainTableViewController.swift
//  ZaloProject
//
//  Created by geotech on 11/09/2021.
//

import Foundation
import UIKit

//MARK: Delegate
extension ViewController:UITableViewDelegate{
    //Search Bar status when scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       
        //delete search bar when scroll
        viewSearchBar.searchBar.setShowsCancelButton(false, animated: true)
        
        viewSearchBar.searchBar.text = ""
        viewSearchBar.searchBar.resignFirstResponder()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        // turn off keyboard when scrolling
        if (offsetY > 1){
            viewSearchBar.dismiss(animated: true)
        }
        
        // loading more image when go down
        if (offsetY > contentHeight - scrollView.frame.height*2 && !isLoading){
            loadMoreData()
        }
    }
}

//MARK: Datasource

extension ViewController:UITableViewDataSource{
    
    //table view datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data.dataAPI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        
        //create data for cell
        do {
            try  cell.populateCell(with: data.dataAPI, userLike: data.userLike, index: indexPath.row)
        } catch DataError.failToUnwrapItems {
            print("Fail to unwrap item")
        }
        catch{
            print("Fail to load cell")
        }
       
        
        //Implement action for like btn
        cell.likeBtnOutlet.tag = indexPath.row
        cell.likeBtnOutlet.addTarget(self, action: #selector(ViewController.likeBtnClicked(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func likeBtnClicked(sender: UIButton?){
        guard let buttonTag = sender?.tag else {return}
        if (data.userLike[buttonTag] == 0){
            data.dataAPI[buttonTag].totalLikes += 1
            data.userLike[buttonTag] = 1
        } else {
            data.dataAPI[buttonTag].totalLikes -= 1
            data.userLike[buttonTag] = 0
        }
        tableView.reloadData()
    }
}

//MARK: Search Bar
extension ViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewSearchBar.searchBar.setShowsCancelButton(true, animated: true)
        viewSearchBar.becomeFirstResponder()
        
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchForKeyword(_:)), userInfo: searchText, repeats: false)
    }
    @objc func searchForKeyword(_ timer: Timer) {
        
        // retrieve the keyword from user info
        let keyword = String(describing: timer.userInfo!)
        
        //reset data
        if (keyword == ""){
            data.currentPage = 1
            data.reset()
            type = 1
            loadData(type:1, APIUrl: "https://api.unsplash.com/photos?page=")
        } else {
            data.currentPage = 1
            data.reset()
            
            //save the search information
            type = 2
            self.keyword = keyword
            
            loadData(type:2, APIUrl: "https://api.unsplash.com/search/photos?query="+keyword+"&page=")
        }
       
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewSearchBar.dismiss(animated: true)
        viewSearchBar.searchBar.setShowsCancelButton(false, animated: true)
        viewSearchBar.searchBar.text = ""
        searchBar.resignFirstResponder()
        
        //Reset Data and reload table
        data.currentPage = 1
        data.reset()
        type = 1
        loadData(type: 1, APIUrl: "https://api.unsplash.com/photos?page=")
        self.tableView.reloadData()
    }
    
}
