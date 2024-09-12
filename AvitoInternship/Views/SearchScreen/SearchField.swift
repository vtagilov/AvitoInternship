//
//  SearchField.swift
//  AvitoInternship
//
//  Created by Владимир on 11.09.2024.
//

import UIKit

final class SearchField: UIView {
    
    var searchAction: ((String) -> Void)?
    var queryWasModified: ((String) -> Void)?
    var cellTypeAction: (() -> Void)?
    var sortButtonAction: ((SearchViewModel.SortType) -> Void)?
    
    private var suggests = [String]()
    
    private let textFieldHeight = 35.0
    private let cellHeight = 30.0
    private let tableOffset = 2.0
    private lazy var heightConstraint: [NSLayoutConstraint] = [
        heightAnchor.constraint(equalToConstant: 35),
        suggetionsTable.heightAnchor.constraint(equalToConstant: 0)
        ]
    
    private lazy var textField: UISearchTextField = {
        let textField = UISearchTextField(frame: .zero)
        textField.returnKeyType = .done
        textField.placeholder = "Поиск фото и иллюстраций"
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicatior = UIActivityIndicatorView(frame: .zero)
        indicatior.style = .medium
        indicatior.hidesWhenStopped = true
        indicatior.translatesAutoresizingMaskIntoConstraints = false
        return indicatior
    }()
    
    private let sortButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        button.imageView?.tintColor = .gray
        button.menu = UIMenu(title: "Сортировать", options: [.singleSelection], children: [
            UIAction(title: "Популярное", state: .on) { _ in },
            UIAction(title: "Новое", state: .on) { _ in },
        ])
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cellTypeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "aspectratio.fill"), for: .normal)
        button.imageView?.tintColor = .gray
        button.addTarget(self, action: #selector(cellTypeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var suggetionsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(SuggestCell.self, forCellReuseIdentifier: SuggestCell.reuseIdentifier)
        table.rowHeight = cellHeight
        table.backgroundColor = .clear
        table.isScrollEnabled = false
        table.isHidden = true
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLoadingStatus(_ isLoading: Bool) {
        isLoading ? (loadingIndicator.startAnimating()) : (loadingIndicator.stopAnimating())
    }
    
    func setSuggests(_ suggests: [String]) {
        self.suggests = suggests
        suggetionsTable.reloadData()
    }
    
    @objc private func cellTypeButtonTapped() {
        self.cellTypeAction?()
    }
    
    private func changeSize() {
        var height = textFieldHeight
        if textField.isEditing , !suggests.isEmpty {
            height += cellHeight * Double(suggests.count) + tableOffset
        }
        NSLayoutConstraint.deactivate(heightConstraint)
        heightConstraint = [
            heightAnchor.constraint(equalToConstant: height),
            suggetionsTable.heightAnchor.constraint(equalToConstant: height - textFieldHeight)
        ]
        NSLayoutConstraint.activate(heightConstraint)
        
        suggetionsTable.isHidden = !textField.isEditing
    }
    
    private func configureView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        for subview in [textField, sortButton, cellTypeButton, loadingIndicator, suggetionsTable] {
            addSubview(subview)
        }
        
        NSLayoutConstraint.activate([
            heightConstraint[0],
            
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: cellTypeButton.leadingAnchor),
            
            loadingIndicator.topAnchor.constraint(equalTo: textField.topAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            loadingIndicator.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            loadingIndicator.heightAnchor.constraint(equalTo: loadingIndicator.widthAnchor, multiplier: 1.0),
            
            sortButton.topAnchor.constraint(equalTo: textField.topAnchor),
            sortButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            sortButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            sortButton.heightAnchor.constraint(equalTo: sortButton.widthAnchor, multiplier: 1.0),
            
            cellTypeButton.topAnchor.constraint(equalTo: textField.topAnchor),
            cellTypeButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            cellTypeButton.trailingAnchor.constraint(equalTo: sortButton.leadingAnchor),
            cellTypeButton.heightAnchor.constraint(equalTo: cellTypeButton.widthAnchor, multiplier: 1.0),
            
            suggetionsTable.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: tableOffset),
            suggetionsTable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            suggetionsTable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
}

extension SearchField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.searchAction?(text)
        changeSize()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        queryWasModified?(textField.text ?? "")
        changeSize()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        queryWasModified?(textField.text ?? "")
        changeSize()
    }
}

extension SearchField: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestCell.reuseIdentifier)
        guard let cell = cell as? SuggestCell else { return UITableViewCell() }
        cell.configure(suggests[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.resignFirstResponder()
        let query = suggests[indexPath.row]
        searchAction?(query)
        textField.text = query
    }
}
