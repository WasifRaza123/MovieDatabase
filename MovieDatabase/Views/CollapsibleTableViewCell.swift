//
//  CollapsibleTableViewCell.swift
//  MovieDatabase
//
//  Created by Mohd Wasif Raza on 12/08/23.
//

import UIKit

class CollapsibleTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // configure nameLabel
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        
        NSLayoutConstraint.activate([
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: nameLabel.bottomAnchor, constant: 10),
        ])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

