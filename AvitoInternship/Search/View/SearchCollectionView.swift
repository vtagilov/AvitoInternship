import UIKit

protocol SearchCollectionViewDelegate: AnyObject {
    func didReachEndOfData()
    func didSelectItem(item: PreviewProduct)
}

final class SearchCollectionView: BaseCollectionView<PreviewProduct, SearchCollectionCell> {
    weak var searchDelegate: SearchCollectionViewDelegate?
    
    init(itemWidth: CGFloat) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 80)
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        super.init(layout: layout)
        showsVerticalScrollIndicator = true
        backgroundColor = .primaryBackground
        contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureCell(_ cell: SearchCollectionCell, with item: PreviewProduct, at indexPath: IndexPath) {
        cell.configureCell(model: item)
    }

    override func didSelectItem(_ item: PreviewProduct, at indexPath: IndexPath) {
        print("SearchCollectionView. didSelectItem:", item)
        searchDelegate?.didSelectItem(item: item)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight * 2 {
            searchDelegate?.didReachEndOfData()
        }
    }
}
