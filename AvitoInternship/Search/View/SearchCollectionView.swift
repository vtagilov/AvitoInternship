import UIKit

protocol SearchCollectionViewDelegate: AnyObject {
    func didReachEndOfData()
}

final class SearchCollectionView: BaseCollectionView<PreviewProduct, SearchCollectionCell> {
    
    weak var searchDelegate: SearchCollectionViewDelegate?

    override func configureCell(_ cell: SearchCollectionCell, with item: PreviewProduct, at indexPath: IndexPath) {
        cell.configureCell(model: item)
    }

    override func didSelectItem(_ item: PreviewProduct, at indexPath: IndexPath) {
        print("didSelectItem", indexPath)
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
