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

            let encodedQuery = self.query!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "https://www.googleapis.com/customsearch/v1?key=AIzaSyB4kzYOkqPMPBmIoLSZTq-uLVrzo2IPVTg&cx=013192398778145171751:ypdvo853wcg&q=\(encodedQuery!)&searchType=image"
        
        let url = URL(string: urlString)

            var responseData = NSDictionary()
            URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
                if error != nil
                {
                    print("Error:\(error!)")
                }
                else
                {
                    do
                    {
                       
                        responseData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    
                        //TODO Check for error/errors/domain: usagelimits, /reason: dailylimitExceeded; return false
                        let resultsDataArray = responseData.value(forKey: "items") as! NSArray

                        var tempResultsArray = [SearchResult]()
                        for resultElement in resultsDataArray{
                            let resultDictionary = resultElement as! NSDictionary
                            var result = SearchResult()
                            result.image = resultDictionary.value(forKey: "image") as? NSDictionary
                            result.thumbnailLink = result.image?.value(forKey: "thumbnailLink") as? String
                            result.contextLink = result.image?.value(forKey: "contextLink") as? String
                            result.title = resultDictionary.value(forKey: "title") as? String
                            result.description = resultDictionary.value(forKey: "snippet") as? String
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
        
            }).resume()
        
        return true
    }
    

    // FETCHMORE func simply GETs more records from API and appends them to the results array
    public func fetchMore ( completion: @escaping ()->()) -> Bool{
        
        let encodedQuery = self.query!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let startIndex = (self.results?.count)! + 1
        let urlString = "https://www.googleapis.com/customsearch/v1?key=AIzaSyB4kzYOkqPMPBmIoLSZTq-uLVrzo2IPVTg&cx=013192398778145171751:ypdvo853wcg&q=\(encodedQuery!)&searchType=image&start=\(startIndex)"
        let url = URL(string: urlString)
        var responseData = NSDictionary()
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil
            {
                print("Error:\(error!)")
            }
            else
            {

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
                        result.title = resultDictionary.value(forKey: "title") as? String
                        result.description = resultDictionary.value(forKey: "snippet") as? String

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
