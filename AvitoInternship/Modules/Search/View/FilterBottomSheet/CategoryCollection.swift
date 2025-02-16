import UIKit

protocol CategoryFilterDelegate: AnyObject {
    func categoryWasTapped(category: Category?)
}

final class CategoryCollectionView: BaseCollectionView<Category, CategoryCell> {
    weak var categoryFilterDelegate: CategoryFilterDelegate?
    
    private var selectedCategoryId: Int?
    
    init(itemWidth: CGFloat) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: 30)
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        super.init(layout: layout)
        backgroundColor = .primaryBackground
        contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureCell(_ cell: CategoryCell, with item: Category, at indexPath: IndexPath) {
        cell.configureCell(model: item, isSelected: item.id == selectedCategoryId)
    }

    override func didSelectItem(_ item: Category, at indexPath: IndexPath) {
        print("SearchCollectionView. didSelectItem:", item)
        guard let cell = cellForItem(at: indexPath) as? CategoryCell else { return }
        if item.id == selectedCategoryId {
            cell.updateState(isSelected: false)
            selectedCategoryId = nil
            categoryFilterDelegate?.categoryWasTapped(category: nil)
        } else {
            if let lastSelectedCell = cellForItem(at: indexPath) as? CategoryCell {
                lastSelectedCell.updateState(isSelected: false)
            }
            cell.updateState(isSelected: true)
            selectedCategoryId = item.id
            categoryFilterDelegate?.categoryWasTapped(category: item)
        }
    }
}
