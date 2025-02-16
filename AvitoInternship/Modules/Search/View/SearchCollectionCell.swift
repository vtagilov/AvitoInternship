import UIKit

final class SearchCollectionCell: UICollectionViewCell, BaseCollectionCell {
    static var reuseIdentifier: String = "SearchCollectionCell"
    
    private let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    private let titleLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 30))
    private let priceLabel = UILabel(frame: CGRect(x: 0, y: 130, width: 100, height: 30))

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(model: PreviewProduct) {
        imageView.image = model.previewImage
        titleLabel.text = model.title
        priceLabel.text = "\(model.price)"
    }
    
    private enum Constants {
        static let labelOffset = 4.0
        static let verticalOffset = 4.0
    }
    
    private func configureView() {
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        priceLabel.font = .boldSystemFont(ofSize: 16)
        for subview in [imageView, titleLabel, priceLabel] {
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.labelOffset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.verticalOffset),
            
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.labelOffset),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
