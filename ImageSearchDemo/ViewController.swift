//
//  ViewController.swift
//  ImageSearchDemo
//
//  Created by Mark Mulvehill on 6/3/18.
//  Copyright © 2018 Adroita. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var searchQueryDelegate: SearchQueryDelegate!
    
    @IBOutlet weak var queryTextField: UITextField!
    @IBAction func searchImageButton(_ sender: UIButton) {
        var search = Search()
        
        //in lieu of input validation, set default search value...
        search.query = "Minneapolis"
        
        search.engine = Search.Engine.GoogleCSE  //TODO: Present engine options to user and pull selected value from UI
        search.imageSearch = true
        
        if queryTextField.text != nil && !(queryTextField.text?.isEmpty)! {
            search.query = queryTextField.text
        }
        
        //TODO: Check for Internet connection, other validation etc.
        
        let success = search.initiate {
            DispatchQueue.main.async {
                //self.searchQueryDelegate.initialFetchComplete(firstFetchSearch: search)
                //pass control
                let resultsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
                self.searchQueryDelegate = resultsViewController
                self.searchQueryDelegate.searchInitiated(initialSearch: search)
                self.present(resultsViewController, animated: true, completion: nil)
                
            }
           
        }

    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

protocol SearchQueryDelegate {
    func searchInitiated(initialSearch: Search)
}


