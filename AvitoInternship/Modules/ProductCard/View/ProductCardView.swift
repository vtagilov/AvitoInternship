import UIKit

protocol ProductCardView: View {
    func appendImage(_ image: UIImage)
}

final class ProductCardViewController: UIViewController, ProductCardView {
    var presenter: ProductCardPresenter!
    
    var previewProduct: PreviewProduct
    
    private var imageCollection: ImageCollectionView!
    private lazy var productTitle = UILabel()
    private lazy var priceLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var imageCounter = UILabel()
    private lazy var backView = UIView()
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    private var loadedImages = 0

    init(previewProduct: PreviewProduct) {
        self.previewProduct = previewProduct
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureView()
    }
    
    func appendImage(_ image: UIImage) {
        imageCollection.updateItem(image, index: IndexPath(row: loadedImages, section: 0))
        loadedImages += 1
    }
    
    private func configureView() {
        view.backgroundColor = .primaryBackground
        navigationController?.navigationBar.isHidden = false
        
        imageCollection = ImageCollectionView(itemWidth: view.frame.width)
        let images = [previewProduct.previewImage] + Array(repeating: UIImage(), count: previewProduct.images.count - 1)
        imageCollection.setItems(images)
        imageCollection.imageDelegate = self
        
        productTitle.textColor = .contentColor
        productTitle.font = .boldSystemFont(ofSize: 28)
        productTitle.text = previewProduct.title
        productTitle.numberOfLines = 0
        
        priceLabel.textColor = .contentColor
        priceLabel.text = "\(previewProduct.price)"
        priceLabel.font = .boldSystemFont(ofSize: 28)
        
        descriptionLabel.textColor = .contentColor
        descriptionLabel.text = previewProduct.description
        descriptionLabel.font = .systemFont(ofSize: 24)
        descriptionLabel.numberOfLines = 0
        
        imageCounter.textColor = .contentColor
        imageCounter.text = "1/\(previewProduct.images.count)"
        
        backView.backgroundColor = .primaryBackground
        backView.layer.cornerRadius = 8
        
        for subview in [imageCollection!, productTitle, priceLabel, descriptionLabel, backView, imageCounter] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subview)
        }
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCollection.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCollection.heightAnchor.constraint(equalTo: imageCollection.widthAnchor),
            
            imageCounter.leadingAnchor.constraint(equalTo: imageCollection.leadingAnchor, constant: 24),
            imageCounter.topAnchor.constraint(equalTo: imageCollection.topAnchor, constant: 12),
            
            backView.leadingAnchor.constraint(equalTo: imageCounter.leadingAnchor, constant: -6),
            backView.trailingAnchor.constraint(equalTo: imageCounter.trailingAnchor, constant: 6),
            backView.topAnchor.constraint(equalTo: imageCounter.topAnchor, constant: -4),
            backView.bottomAnchor.constraint(equalTo: imageCounter.bottomAnchor, constant: 4),
            
            productTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            productTitle.topAnchor.constraint(equalTo: imageCollection.bottomAnchor, constant: 8),
            
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            priceLabel.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

extension ProductCardViewController: ImageCollectionViewDelegate {
    func showCell(at index: IndexPath) {
        imageCounter.text = "\(index.row + 1)/\(previewProduct.images.count)"
    }
}
