//
//  SectionController.swift
//  SXStatus
//
//  Created by Mark Malstrom on 3/13/17.
//  Copyright © 2017 Tangaroa. All rights reserved.
//

import UIKit
import IGListKit
import SafariServices

class SectionController: IGListSectionController, IGListSectionType {
    var event: Event!
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func numberOfItems() -> Int {
        if event.eventName.isEmpty || event.eventTime.isEmpty {
            return 0
        } else {
            return 1
        }
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: 0.96 * UIScreen.main.bounds.width, height: 74) // two line label height == 92
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: EventCell.self, for: self, at: index) as! EventCell
        
        cell.eventNameLabel.text = event.eventName
        cell.eventTimeLabel.text = event.eventTime.replacingOccurrences(of: ".", with: "")
        cell.venueNameLabel.text = event.venueName.uppercased()
        cell.statusColor = event.status
        
        return cell
    }
    
    // Maybe called when data is refreshed from API?
    func didUpdate(to object: Any) {
        self.event = object as! Event
    }
    
    func didSelectItem(at index: Int) {
        if let url = self.event.filmLink?.url {
            let svc = SFSafariViewController(url: url)
            
            if #available(iOS 10.0, *) {
                svc.preferredBarTintColor = #colorLiteral(red: 0.05098039216, green: 0.05098039216, blue: 0.05098039216, alpha: 1)
                svc.preferredControlTintColor = event.status.color
            } else {
                svc.view.tintColor = event.status.color
            }
            
            self.viewController?.present(svc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "No Website Found for \(event.eventName)", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.view.tintColor = event.status.color
            self.viewController?.present(alert, animated: true, completion: nil)
        }
    }
}
