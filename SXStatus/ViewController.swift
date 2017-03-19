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
    
    var refreshControl: UIRefreshControl!
    let collectionView = IGListCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        // PDF image for Navigation Bar title
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
        /* EventClient.shared.getEvents { (events) in
            self.events = events
            self.adapter.reloadData(completion: nil)
            self.refreshControl.endRefreshing()
        } */
        
        EventClient.shared.getExampleEvents { (events) in
            self.events = events.sorted()
            self.adapter.reloadData(completion: nil)
            self.refreshControl.endRefreshing()
        }
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



