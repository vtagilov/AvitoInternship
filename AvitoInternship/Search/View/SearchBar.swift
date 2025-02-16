import UIKit

protocol SearchBarDelegate: AnyObject {
    func searchButtonClicked(text: String?)
    func filterButtonTapped()
}

final class SearchBar: UIView {
    
    weak var searchDelegate: SearchBarDelegate?
    
    var text: String? {
        searchBar.text == "" ? nil : searchBar.text
    }
    
    private let searchBar = UISearchBar(frame: .zero)
    private let cancelButton = UIButton(frame: .zero)
    private let filterButton = UIButton(frame: .zero)
    private var searchBarTrailingConstraint: NSLayoutConstraint!

    init() {
        super.init(frame: .zero)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        searchBar.searchTextField.enablesReturnKeyAutomatically = false
        searchBar.delegate = self
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.placeholder = "Search"
        
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        filterButton.imageView?.tintColor = .contentColor
        filterButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.contentColor, for: .normal)
        cancelButton.isHidden = true
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        for subview in [filterButton, cancelButton, searchBar] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        searchBarTrailingConstraint = searchBar.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBarTrailingConstraint,
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            filterButton.heightAnchor.constraint(equalTo: filterButton.widthAnchor),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterButton.topAnchor.constraint(equalTo: topAnchor),
            filterButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            cancelButton.topAnchor.constraint(equalTo: topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func filterButtonTapped() {
        searchDelegate?.filterButtonTapped()
    }
    
    @objc private func cancelButtonTapped() {
        searchBar.resignFirstResponder()
    }
}

extension SearchBar: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        filterButton.isHidden = true
        cancelButton.isHidden = false
        searchBarTrailingConstraint.isActive = false
        searchBarTrailingConstraint = searchBar.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor)
        searchBarTrailingConstraint.isActive = true
        return true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        filterButton.isHidden = false
        cancelButton.isHidden = true
        searchBarTrailingConstraint.isActive = false
        searchBarTrailingConstraint = searchBar.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor)
        searchBarTrailingConstraint.isActive = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text:", searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text == "" ? nil : searchBar.text
        searchBar.resignFirstResponder()
        searchDelegate?.searchButtonClicked(text: text)
    }
}
