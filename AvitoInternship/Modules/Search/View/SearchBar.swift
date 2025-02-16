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
    
    private lazy var searchBar = UISearchBar(frame: .zero)
    private lazy var suggestsTableView = UITableView(frame: .zero)
    private lazy var cancelButton = UIButton(frame: .zero)
    private lazy var filterButton = UIButton(frame: .zero)
    private var searchBarTrailingConstraint: NSLayoutConstraint!
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    private lazy var queryStorage = QueryStorage()
    
    private lazy var suggestions: [String] = queryStorage.lastQueries

    init() {
        super.init(frame: .zero)
        configureView()
        updateTableViewHeight()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        suggestsTableView.dataSource = self
        suggestsTableView.delegate = self
        suggestsTableView.isScrollEnabled = false
        suggestsTableView.register(SearchSuggestionCell.self, forCellReuseIdentifier: SearchSuggestionCell.identifier)
        
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
        
        for subview in [filterButton, cancelButton, searchBar, suggestsTableView] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
        configureConstraints()
    }
    
    private func configureConstraints() {
        searchBarTrailingConstraint = searchBar.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor)
        tableViewHeightConstraint = suggestsTableView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBarTrailingConstraint,
            searchBar.topAnchor.constraint(equalTo: topAnchor),
//            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            filterButton.heightAnchor.constraint(equalTo: filterButton.widthAnchor),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterButton.topAnchor.constraint(equalTo: searchBar.topAnchor),
            filterButton.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor),
            
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            cancelButton.topAnchor.constraint(equalTo: searchBar.topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor),
            
            suggestsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            suggestsTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            suggestsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            suggestsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableViewHeightConstraint
//            suggestsTableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func updateTableViewHeight(isHidden: Bool = false) {
        let contentHeight = suggestsTableView.contentSize.height
        var maxHeight: CGFloat = 200
        if isHidden { maxHeight = 0 }
        tableViewHeightConstraint?.constant = min(contentHeight, maxHeight)

        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
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
        suggestsTableView.reloadData()
        updateTableViewHeight()
        filterButton.isHidden = true
        cancelButton.isHidden = false
        suggestsTableView.isHidden = false
        searchBarTrailingConstraint.isActive = false
        searchBarTrailingConstraint = searchBar.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor)
        searchBarTrailingConstraint.isActive = true
        return true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        filterButton.isHidden = false
        cancelButton.isHidden = true
        suggestsTableView.isHidden = true
        tableViewHeightConstraint = suggestsTableView.heightAnchor.constraint(equalToConstant: 0)
        updateTableViewHeight(isHidden: true)
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
        if let text = text {
            queryStorage.saveQuery(text)
            suggestions = queryStorage.lastQueries.reversed()
        }
    }
}

extension SearchBar: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchSuggestionCell.identifier,
            for: indexPath
        ) as? SearchSuggestionCell else {
            return UITableViewCell()
        }
        cell.configure(with: suggestions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedText = suggestions[indexPath.row]
        searchBar.text = selectedText
        
//        onSelectSuggestion?(selectedText)
        tableView.isHidden = true
        searchBar.resignFirstResponder()
    }
}

final class SearchSuggestionCell: UITableViewCell {
    static let identifier = "SearchSuggestionCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .contentColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func configure(with text: String) {
        titleLabel.text = text
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
