import UIKit

final class ImageCell: UICollectionViewCell, BaseCollectionCell {
    static var reuseIdentifier = "ImageCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(model: UIImage) {
        self.imageView.image = model
        activityIndicator.isHidden = true
    }
    
    func makeLoadingCell() {
        activityIndicator.isHidden = false
    }
}
