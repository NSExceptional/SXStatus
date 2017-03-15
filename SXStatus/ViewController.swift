//
//  ViewController.swift
//  SXStatus
//
//  Created by Mark Malstrom on 3/12/17.
//  Copyright © 2017 Tangaroa. All rights reserved.
//

import UIKit
import JSON
import IGListKit

class ViewController: UIViewController, IGListAdapterDataSource {
    var events = [Event]()
    var filmLinks = [FilmLink]()
    
    var refreshControl: UIRefreshControl!
    let collectionView = IGListCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FilmLinkManager.shared.createLink { (links) in
            self.filmLinks = links
        }
        
        self.collectionView.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
        self.view.addSubview(collectionView)
        self.adapter.collectionView = collectionView
        self.adapter.dataSource = self
        
        // Pull to Refresh
        self.refreshControl = UIRefreshControl()
        self.collectionView.alwaysBounceVertical = true
        self.refreshControl.addTarget(self, action: #selector(updateEvents), for: .valueChanged)
        self.collectionView.addSubview(refreshControl)
        self.refreshControl.tintColor = .white
        // Make the spinner appear behind the cells
        self.refreshControl.layer.zPosition = -1
        
        self.refreshControl.beginRefreshing()
        self.updateEvents()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = self.view.bounds
    }
    
    // MARK: API call
    
    func updateEvents() {
        let url = URL(string: "http://vsb.sxsw.com/api/_design/app/_view/venues")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Accept" : "application/json"]
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error == nil {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                if let data = data, 200..<300 ~= statusCode {
                    
                    // Parse JSON, refresh view
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        let eventsJSON: [JSONDictionary] = try! JSON.decode(json as! JSONDictionary, key: "rows")
                        self.events = eventsJSON.flatMap({ (eventJSON) -> Event in
                            let name: String = try! decode(eventJSON, keyPath: "value.event_name")
                            
                            for link in self.filmLinks {
                                if link.name == name {
                                    return try! Event(jsonRepresentation: eventJSON, filmLink: link)
                                }
                            }
                            
                            return try! Event(jsonRepresentation: eventJSON)
                        })
                        self.events.sort(by: { (eventOne, eventTwo) -> Bool in
                            if eventOne.eventTime.contains("AM") {
                                if eventTwo.eventTime.contains("AM") {
                                    return eventOne.eventTime < eventTwo.eventTime
                                }
                                
                                return true
                            } else {
                                return eventOne.eventTime < eventTwo.eventTime
                            }
                        })
                        self.adapter.reloadData(completion: nil)
                        self.refreshControl.endRefreshing()
                    } else {
                        // display error to user
                    }
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        }).resume()
    }
    
    // MARK: IGListAdapterDataSource
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return self.events
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return SectionController()
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
}



