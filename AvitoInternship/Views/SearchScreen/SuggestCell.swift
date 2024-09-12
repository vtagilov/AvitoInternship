//
//  SuggestCell.swift
//  AvitoInternship
//
//  Created by Владимир on 12.09.2024.
//

import UIKit

final class SuggestCell: UITableViewCell {
    static let reuseIdentifier = "SuggestTableViewCell"
    
    private let label = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = ""
    }
    
    func configure(_ text: String) {
        label.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 5, y: 0, width: frame.width, height: frame.height)
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        layer.cornerRadius = 8
        clipsToBounds = true
        self.contentView.addSubview(label)
    }
}
