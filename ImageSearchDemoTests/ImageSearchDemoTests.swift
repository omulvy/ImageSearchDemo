//
//  ImageSearchDemoTests.swift
//  ImageSearchDemoTests
//
//  Created by Mark Mulvehill on 6/3/18.
//  Copyright © 2018 Adroita. All rights reserved.
//

import XCTest
@testable import ImageSearchDemo

class ImageSearchDemoTests: XCTestCase {
    
    var viewController: ViewController!
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewController = storyboard.instantiateInitialViewController() as! ViewController
    }
    
    func testInitiateSearch(){
        let searchObject = Search()
        searchObject.initiate {
            //TODO
        }
    }
    
    func testFetchMore(){
        let searchObject = Search()
        searchObject.fetchMore {
            //TODO
        }
    }
    
    func testSearch(){
        let searchObject = Search()
        //TODO Test that data model matches expecations across:
        // Format of results from search engine(s), json parsed data, search object, consumers of search object (results and detail VCs)
        

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
