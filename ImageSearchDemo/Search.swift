//
//  Search.swift
//  ImageSearchDemo
//
//  Created by Mark Mulvehill on 6/3/18.
//  Copyright © 2018 Adroita. All rights reserved.
//

import Foundation
import UIKit

class Search: NSObject{
    
    var imageSearch : Bool = false   // default is not imageSearch
 

    let GoogleCSE = 1
    let Bing = 2
    var engine: Engine! //Google, Bing etc.
    var query: String!  //AKA "Search Expression"
    //var parameters: Dictionary? <...>  //TODO add optional parameters to search ??dependent on type & engine?
    var results: [SearchResult]?
    
    public enum Engine {
        case GoogleCSE
        case Bing
    }
    
    
    // this INITIATE function retrieves the first batch of results (qty of records is simply the API's default number) and is intended to be called prior to and asynchronously from the presentation of the view that will display the results.
    public func initiate ( completion: @escaping ()->()) -> Bool{
        //TODO: if GooglCSE (vs. Bing)
        //TODO: if text search vs. Image Search
        
        
        // https://www.googleapis.com/customsearch/v1?key=AIzaSyB4kzYOkqPMPBmIoLSZTq-uLVrzo2IPVTg&cx=013192398778145171751:ypdvo853wcg&q=Minneapolis&searchType=image

            debugPrint("query \(self.query!)")
            let encodedQuery = self.query!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "https://www.googleapis.com/customsearch/v1?key=AIzaSyB4kzYOkqPMPBmIoLSZTq-uLVrzo2IPVTg&cx=013192398778145171751:ypdvo853wcg&q=\(encodedQuery!)&searchType=image"
        
        debugPrint("string pre-url \(urlString)")
        let url = URL(string: urlString)
            debugPrint("Get URL Used: \(url!)")
            var responseData = NSDictionary()
            URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
                if error != nil
                {
                    print("Error:\(error!)")
                }
                else
                {
                    print("Else loop on URLSession.shared.dataTask...")
                    do
                    {
                       
                        responseData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        let resultsDataArray = responseData.value(forKey: "items") as! NSArray
                        print("ResultsArray count: \(resultsDataArray.count)")
                        var tempResultsArray = [SearchResult]()
                        for resultElement in resultsDataArray{
                            let resultDictionary = resultElement as! NSDictionary
                            var result = SearchResult()
                            result.image = resultDictionary.value(forKey: "image") as? NSDictionary
                            result.thumbnailLink = result.image?.value(forKey: "thumbnailLink") as? String
                            result.contextLink = result.image?.value(forKey: "contextLink") as? String
                            //use image/thumbnailLink (appears to always be ssl)
                            debugPrint("link: "+"\(String(describing: result.thumbnailLink))")
                            result.title = resultDictionary.value(forKey: "title") as? String
                            //debugPrint
                            result.description = resultDictionary.value(forKey: "snippet") as? String
                            //debugPrint
                            tempResultsArray.append(result)
                        }
                        self.results = tempResultsArray
                        completion()
                    }
                    catch let error as NSError
                    {
                        print("Caught:\(error)")
                    }
                }
                print("hook?")
            }).resume()
      
        
        
        return true
    }
    

    // FETCHMORE func simply GETs more records from API and appends them to the results array
    public func fetchMore ( completion: @escaping ()->()) -> Bool{
        
        debugPrint("query \(self.query!)")
        let encodedQuery = self.query!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let startIndex = (self.results?.count)! + 1
        
        
        let urlString = "https://www.googleapis.com/customsearch/v1?key=AIzaSyB4kzYOkqPMPBmIoLSZTq-uLVrzo2IPVTg&cx=013192398778145171751:ypdvo853wcg&q=\(encodedQuery!)&searchType=image&start=\(startIndex)"
        
        debugPrint("string pre-url \(urlString)")
        let url = URL(string: urlString)
        debugPrint("Get URL Used: \(url!)")
        var responseData = NSDictionary()
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil
            {
                print("Error:\(error!)")
            }
            else
            {
                print("Else loop on URLSession.shared.dataTask...")
                do
                {
                    
                    responseData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    let resultsDataArray = responseData.value(forKey: "items") as! NSArray
                    print("ResultsArray count: \(resultsDataArray.count)")
                    var tempResultsArray = [SearchResult]()
                    for resultElement in resultsDataArray{
                        let resultDictionary = resultElement as! NSDictionary
                        var result = SearchResult()
                        result.image = resultDictionary.value(forKey: "image") as? NSDictionary
                        result.thumbnailLink = result.image?.value(forKey: "thumbnailLink") as? String
                        result.contextLink = result.image?.value(forKey: "contextLink") as? String
                        //use image/thumbnailLink (appears to always be ssl)
                        debugPrint("link: "+"\(String(describing: result.thumbnailLink))")
                        result.title = resultDictionary.value(forKey: "title") as? String
                        //debugPrint
                        result.description = resultDictionary.value(forKey: "snippet") as? String
                        //debugPrint
                        tempResultsArray.append(result)
                    }
                    self.results?.append(contentsOf: tempResultsArray)
                    completion()
                }
                catch let error as NSError
                {
                    print("Caught:\(error)")
                }
            }
            print("hook?")
        }).resume()
        
        
        
        return true
    }
    
    override init() {
        //TODO
    }
    
    deinit {
        //TODO
    }
}
