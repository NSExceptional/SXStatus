//
//  EventCell.swift
//  SXStatus
//
//  Created by Mark Malstrom on 3/13/17.
//  Copyright © 2017 Tangaroa. All rights reserved.
//

import UIKit
import SnapKit

class EventCell: UICollectionViewCell {
    // Labels
    let venueNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
        label.textAlignment = .left
        label.text = "Venue Name".uppercased()
        label.numberOfLines = 1
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    let eventTimeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
        label.textAlignment = .right
        label.text = "9:41 AM"
        label.numberOfLines = 1
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    let eventNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)
        label.textAlignment = .left
        label.text = "Event Name"
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    // Views
    private let headerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.15)
        return view
    }()
    
    private let bodyView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    private let venueAndTimeStackView: UIStackView
    
    var statusColor: Status {
        didSet {
            self.contentView.backgroundColor = self.statusColor.color
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("For Storyboards -- Not Using")
    }
    
    override init(frame: CGRect) {
        self.venueAndTimeStackView = UIStackView(arrangedSubviews: [venueNameLabel, eventTimeLabel])
        self.statusColor = .red
        
        super.init(frame: frame)
        
        self.venueAndTimeStackView.axis = .horizontal
        self.venueAndTimeStackView.distribution = .fill
        self.venueAndTimeStackView.alignment = .top
        
        self.contentView.layer.cornerRadius = 13
        self.contentView.clipsToBounds = true
        
        self.headerView.addSubview(venueAndTimeStackView)
        self.bodyView.addSubview(eventNameLabel)
        
        self.contentView.addSubview(headerView)
        self.contentView.addSubview(bodyView)
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func updateConstraints() {        
        self.headerView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        self.venueAndTimeStackView.snp.updateConstraints { (make) in
            make.left.right.equalToSuperview().inset(8)
            make.center.equalToSuperview()
        }
        
        self.bodyView.snp.updateConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        self.eventNameLabel.snp.updateConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
