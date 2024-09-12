//
//  SearchCell.swift
//  AvitoInternship
//
//  Created by Владимир on 11.09.2024.
//

import UIKit

final class SearchCell: UICollectionViewCell {
    static let reuseIdentifier = "SearchCollectionViewCell"
    private var id: String = ""
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let width = frame.width
        let height = frame.height
        imageView.layer.cornerRadius = contentView.layer.cornerRadius
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: width)
        label.frame = CGRect(x: 0, y: width, width: width, height: height - width)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        id = ""
        imageView.image = nil
        label.text = nil
    }
    
    func configure(_ model: SearchModel) {
        if id == model.id { return }
        id = model.id
        imageView.image = UIImage(data: model.imageData)
        label.text = model.description
    }
    
    private func configureView() {
        contentView.layer.cornerRadius = 8
        clipsToBounds = true
        for subview in [imageView, label] {
            contentView.addSubview(subview)
        }
    }
}
