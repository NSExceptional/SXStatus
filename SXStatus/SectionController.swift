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
    
    func numberOfItems() -> Int {
        // Don't display a cell if the eventName or eventTime is an empty string
        if event.eventName.isEmpty || event.eventTime.isEmpty {
            return 0
        } else {
            // Only add spacing in between the cell if there is a cell being returned
            self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
            return 1
        }
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: 0.96 * UIScreen.main.bounds.width, height: collectionContext!.containerSize.width)
//        return CGSize(width: 0.96 * UIScreen.main.bounds.width, height: 74) // two line label height == 92
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: EventCell.self, for: self, at: index) as! EventCell
        
        cell.eventNameLabel.text = event.eventName
        // Sometimes the API returns "AM" and sometimes "A.M."
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
        // If the Event was found in films.json
        if let url = self.event.url {
            let svc = SFSafariViewController(url: url)
            
            if #available(iOS 10.0, *) {
                svc.preferredBarTintColor = #colorLiteral(red: 0.05098039216, green: 0.05098039216, blue: 0.05098039216, alpha: 1)
                svc.preferredControlTintColor = event.status.color
            } else {
                svc.view.tintColor = event.status.color
            }
            
            self.viewController?.present(svc, animated: true, completion: nil)
        // If the Event was not found in films.json
        } else {
            let alert = UIAlertController(title: "No Website Found for \(event.eventName)", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.view.tintColor = event.status.color
            
            self.viewController?.present(alert, animated: true, completion: nil)
        }
    }
}
