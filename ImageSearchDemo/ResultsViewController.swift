//
//  ResultsViewController.swift
//  ImageSearchDemo
//
//  Created by Mark Mulvehill on 6/3/18.
//  Copyright © 2018 Adroita. All rights reserved.
//

import Foundation
import UIKit

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let storyboardIdentifier = "ResultsViewController"
    
    @IBOutlet weak var tableView: UITableView!
    var searchQueryDelegate: SearchQueryDelegate!
    var search: Search?
    var detailResultViewController: DetailResultViewController!
    var showResultDelegate: ShowResultDelegate!
    var fetchingNow = false //For this demo slowing down parallel fetching, forcing serial/one-at-a-time fetching
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailResultViewController") as! DetailResultViewController
        self.showResultDelegate = detailResultViewController
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO
        if let cellCount = search?.results?.count{
            return cellCount
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO
        let resultCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "resultCell")
        resultCell.contentView.layer.borderWidth = 1
        resultCell.textLabel?.text = search?.results?[indexPath.row].title
        resultCell.detailTextLabel?.text = search?.results?[indexPath.row].description
        // call asynch image load using cse_thumbnail src
        // This could also be made async if thumbnails load slow
        let url = URL(string: (search?.results?[indexPath.row].thumbnailLink)!)
        let data = try? Data(contentsOf: url!)
        resultCell.imageView?.image = UIImage(data: data!)
        
        //prefetch x records worth of data if after last fetch is complete
        let fetchAheadCount = 10
        let maxAPICount = 31
        if (((search?.results?.count)! - indexPath.row) < fetchAheadCount) && !fetchingNow{
            if ((search?.results?.count)! < maxAPICount){
                fetchingNow = true
                let success = self.search?.fetchMore{
                        DispatchQueue.main.async {
                            tableView.reloadData()
                            self.fetchingNow = false
                        }
                }//TODO capture API results limit
            }
        }
        return resultCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //TODO kill any active or queued fetches
        //pass search.searchResult
        self.showResultDelegate.setResult(result: (search?.results![indexPath.row])!)
        self.present(detailResultViewController, animated: true, completion: nil)
    }
    
    
}

extension ResultsViewController: SearchQueryDelegate {
    func searchInitiated(initialSearch: Search) {
        //search object acquired
        self.search = initialSearch
    }
    
}
protocol ShowResultDelegate {
    func setResult(result: SearchResult)

}


