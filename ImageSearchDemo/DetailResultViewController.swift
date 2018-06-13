//
//  DetailResultViewController.swift
//  ImageSearchDemo
//
//  Created by Mark Mulvehill on 6/12/18.
//  Copyright © 2018 Adroita. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class DetailResultViewController: UIViewController, WKUIDelegate  {
    
    var webView: WKWebView!
    var searchResult: SearchResult?
    
    
    static let storyboardIdentifier = "DetailResultViewController"
    var showResultDelegate: ShowResultDelegate!
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        let url = URL(string: (searchResult?.contextLink)!)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
}
extension DetailResultViewController: ShowResultDelegate {
    func setResult(result: SearchResult) {
        //search result acquired
        self.searchResult = result
    }
}

