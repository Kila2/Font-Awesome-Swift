//
//  ViewController.swift
//  AF Swift
//
//  Created by Patrik Vaberer on 7/13/15.
//  Copyright (c) 2015 Patrik Vaberer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bGithub: UIBarButtonItem!
    @IBOutlet weak var bTwitter: UIBarButtonItem!
    
    private var filteredData = [String]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
        bGithub.setFAIcon(icon: FABrands.FABGithub, iconSize: 35)
        bTwitter.setFAIcon(icon: FABrands.FABTwitter, iconSize: 35)
    }
    
    @IBAction func bGithubPressed(sender: UIBarButtonItem) {
        if let requestUrl = NSURL(string: "https://github.com/Vaberer/Font-Awesome-Swift") {
            UIApplication.shared.openURL(requestUrl as URL)
        }
    }
    
    @IBAction func bTwitterPressed(sender: UIBarButtonItem) {
        if let twitterURL = NSURL(string: "twitter://user?id=2271666416") {
            if UIApplication.shared.canOpenURL(twitterURL as URL) {
                UIApplication.shared.openURL(twitterURL as URL)
                
            } else if let requestUrl = NSURL(string: "https://twitter.com/vaberer") {
                UIApplication.shared.openURL(requestUrl as URL)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "IconCell") as! IconCell
        let faName = resultSearchController.isActive ? filteredData[indexPath.row] : Helper.FANames[indexPath.row]
        c.lFont.text = faName
        var type:Any
        if(faName.starts(with: "FAB")) {
            type = FABrands.self
        }
        else if (faName.starts(with: "FAS")) {
            type = FASolid.self
        }
        else if (faName.starts(with: "FAR")) {
            type = FARegular.self
        }
        else {
            return UITableViewCell()
        }
        
        guard let icon = resultSearchController.isActive ? FATypeHelper.rawValue(rawValue: Helper.FANames.index(of: filteredData[indexPath.row])!, type: type): FATypeHelper.rawValue(rawValue: indexPath.row ,type:type) else {
            return UITableViewCell()
        }
        
        c.lSmall.FAIcon = icon
        c.lMedium.FAIcon = icon
        c.lBig.FAIcon = icon
        c.iIcon.setFAIconWithName(icon: icon, textColor: UIColor.black)
        return c
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSearchController.isActive ? filteredData.count :  FATypeHelper.count
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredData = []
        filterContentForSearchText(searchText: searchController.searchBar.text!.lowercased())
        self.tableView.reloadData()
    }
    
    private func initialize() {
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.delegate = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.searchBar.searchBarStyle = .minimal
        resultSearchController.searchBar.barTintColor = UIColor.blue
        resultSearchController.searchBar.placeholder = "Type Icon Name"
        tableView.tableHeaderView = resultSearchController.searchBar
    }
    
    private func filterContentForSearchText(searchText: String) {
        for f in Helper.FANames {
            if f.lowercased().range(of: searchText.lowercased()) != nil {
                filteredData.append(f)
            }
        }
    }
}
