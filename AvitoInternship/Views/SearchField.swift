//
//  SearchField.swift
//  AvitoInternship
//
//  Created by Владимир on 11.09.2024.
//

import UIKit

final class SearchField: UIView {
    
    var searchAction: ((String) -> Void)?
    var cellTypeAction: (() -> Void)?
    var sortButtonAction: ((SearchViewModel.SortType) -> Void)?
    
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
            UIAction(title: "Популярное", state: .on) { _ in
                
            },
            UIAction(title: "Новое", state: .on) { _ in
                
            }
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
    
    @objc private func cellTypeButtonTapped() {
        self.cellTypeAction?()
    }
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        for subview in [textField, sortButton, cellTypeButton, loadingIndicator] {
            addSubview(subview)
        }
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: cellTypeButton.leadingAnchor),
            
            loadingIndicator.topAnchor.constraint(equalTo: topAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            loadingIndicator.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            loadingIndicator.heightAnchor.constraint(equalTo: loadingIndicator.widthAnchor, multiplier: 1.0),
            
            sortButton.topAnchor.constraint(equalTo: topAnchor),
            sortButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            sortButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            sortButton.heightAnchor.constraint(equalTo: sortButton.widthAnchor, multiplier: 1.0),
            
            cellTypeButton.topAnchor.constraint(equalTo: topAnchor),
            cellTypeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellTypeButton.trailingAnchor.constraint(equalTo: sortButton.leadingAnchor),
            cellTypeButton.heightAnchor.constraint(equalTo: cellTypeButton.widthAnchor, multiplier: 1.0),
        ])
    }
}

extension SearchField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.searchAction?(text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
