import UIKit

protocol BaseCollectionCell: UICollectionViewCell {
    static var reuseIdentifier: String { get }
}

class BaseCollectionView<Model, Cell: BaseCollectionCell>:
    UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {

    private var models = [Model]()

    init(layout: UICollectionViewFlowLayout) {
        super.init(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        delegate = self
        dataSource = self
        register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        showsVerticalScrollIndicator = false
    }

    func addItems(_ newModels: [Model]) {
        let newItems = models.count ..< (models.count + newModels.count)
        let indexPaths = newItems.map { IndexPath(row: $0, section: 0) }
        models += newModels
        insertItems(at: indexPaths)
    }

    func configureCell(_ cell: Cell, with item: Model, at indexPath: IndexPath) {
        fatalError("Должен быть переопределен в подклассе")
    }

    func didSelectItem(_ item: Model, at indexPath: IndexPath) { }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.reuseIdentifier,
            for: indexPath
        ) as? Cell else { return UICollectionViewCell() }
        let model = models[indexPath.row]
        configureCell(cell, with: model, at: indexPath)
        return cell
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        didSelectItem(model, at: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { }
}
