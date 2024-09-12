//
//  SearchCollection.swift
//  AvitoInternship
//
//  Created by Владимир on 11.09.2024.
//

import UIKit

final class SearchCollection: UICollectionView {
    enum CellType {
        case list, table
    }
    var type: CellType = .table
    
    var models: [SearchModel] = []
    
    private let offset = 5.0
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? SearchCell else { return UICollectionViewCell() }
        cell.configure(models[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItem", models[indexPath.row])
    }
}

extension SearchCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = frame.width
        let cellsPerLine = type == .list ? 1.0 : 2.0
        let width = collectionWidth / cellsPerLine - offset * (cellsPerLine - 1)
        let ratio = type == .list ? 1.1 : 1.25
        return CGSize(width: width, height: width * ratio)
    }
}
