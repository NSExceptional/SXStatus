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
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: 0.96 * UIScreen.main.bounds.width, height: 74) //92
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
                
                switch event.status {
                case .green:
                    svc.preferredControlTintColor = #colorLiteral(red: 0.262745098, green: 0.6274509804, blue: 0.2784313725, alpha: 1)
                case .yellow:
                    svc.preferredControlTintColor = #colorLiteral(red: 0.9764705882, green: 0.6588235294, blue: 0.1450980392, alpha: 1)
                case .red:
                    svc.preferredControlTintColor = #colorLiteral(red: 0.7764705882, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
                }
                
            } else {
                switch event.status {
                case .green:
                    svc.view.tintColor = #colorLiteral(red: 0.262745098, green: 0.6274509804, blue: 0.2784313725, alpha: 1)
                case .yellow:
                    svc.view.tintColor = #colorLiteral(red: 0.9764705882, green: 0.6588235294, blue: 0.1450980392, alpha: 1)
                case .red:
                    svc.view.tintColor = #colorLiteral(red: 0.7764705882, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
                }
            }
            
            self.viewController?.present(svc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "No Info Site Found For \(event.eventName)", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.view.tintColor = #colorLiteral(red: 0.262745098, green: 0.6274509804, blue: 0.2784313725, alpha: 1)
            self.viewController?.present(alert, animated: true, completion: nil)
        }
    }
}
