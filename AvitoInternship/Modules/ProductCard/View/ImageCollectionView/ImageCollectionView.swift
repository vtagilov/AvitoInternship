import UIKit

protocol ImageCollectionViewDelegate: AnyObject {
    func showCell(at index: IndexPath)
}

final class ImageCollectionView: BaseCollectionView<UIImage, ImageCell> {
    weak var imageDelegate: ImageCollectionViewDelegate?
    
    init(itemWidth: CGFloat) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .horizontal
        super.init(layout: layout)
        showsHorizontalScrollIndicator = false
        backgroundColor = .primaryBackground
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureCell(_ cell: ImageCell, with item: UIImage, at indexPath: IndexPath) {
        cell.configureCell(model: item)
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        imageDelegate?.showCell(at: indexPath)
    }
}
