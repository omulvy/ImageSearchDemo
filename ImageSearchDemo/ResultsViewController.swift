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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        debugPrint("view did load results vc")
        detailResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailResultViewController") as! DetailResultViewController
        self.showResultDelegate = detailResultViewController
  
    }
  
  //  let ResultsViewController.delegate

    
  
    
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
        let resultCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "resultCell")
        resultCell.contentView.layer.borderWidth = 1
        resultCell.textLabel?.text = search?.results?[indexPath.row].title
        resultCell.detailTextLabel?.text = search?.results?[indexPath.row].description
        //call asynch image load using cse_thumbnail src
        // This could also be made async if thumbnails load slow
        let url = URL(string: (search?.results?[indexPath.row].thumbnailLink)!)
        debugPrint("TableView URL: \(url)")
        let data = try? Data(contentsOf: url!)
        resultCell.imageView?.image = UIImage(data: data!)
        
        //prefetch 30 records worth of data
        let fetchAheadCount = 30
        let maxAPICount = 100
        if (((search?.results?.count)! - indexPath.row) < fetchAheadCount){
            if ((search?.results?.count)! < maxAPICount){
                let success = self.search?.fetchMore{
                        DispatchQueue.main.async {
                            tableView.reloadData()
                        }
                }
            }
        }
        
        debugPrint("Index: \(indexPath.row)  with Results Count: \(self.search?.results?.count)")
        return resultCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("You selected cell number: \(indexPath.row)!")
        //kill any active fetches
        //pass search.searchResult
       
     
        self.showResultDelegate.setResult(result: (search?.results![indexPath.row])!)
        self.present(detailResultViewController, animated: true, completion: nil)
    }
    
    
}

extension ResultsViewController: SearchQueryDelegate {
    func searchInitiated(initialSearch: Search) {
        //search object acquired
        self.search = initialSearch
        debugPrint("In delegate call. count: \(search?.results?.count)")
    }
    
    func initialFetchComplete(firstFetchSearch: Search) {
        //first batch is received, add to table
        debugPrint("In delegate call fetch complete. count: \(firstFetchSearch.results!.count)")
        //for delta from initial to first Fetch, add to array, then insert cells
        //TODO: DELTA  //FOR BETA Assume initial is zero
        self.search?.results?.append(contentsOf: firstFetchSearch.results!)
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        self.tableView.endUpdates()
        
    }
    
}
protocol ShowResultDelegate {
    func setResult(result: SearchResult)

}


