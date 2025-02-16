import UIKit

struct FilterContext {
    let selectedCategory: Int?
    let minPrice: Int?
    let maxPrice: Int?
    
    func convertToUrlParams() -> [Endpoint.QueryParameter: String?] {
        return [
            .priceMin: minPrice.map { "\($0)" } ?? (maxPrice != nil ? "0" : nil),
            .priceMax: maxPrice.map { "\($0)" } ?? (minPrice != nil ? "\(Int.max)" : nil),
            .categoryId: selectedCategory.map { "\($0)" }
        ]
    }
}

protocol FilterBottomSheetDelegate: AnyObject {
    func setFilterContext(_ context: FilterContext)
}

final class FilterBottomSheet: UIViewController {
    weak var delegate: FilterBottomSheetDelegate?
    
    private var models = [Category]()
    private var context: FilterContext?
    
    private var selectedModel: Category?
    
    private var categoryCollection: CategoryCollectionView!
    private lazy var priceLabel = UILabel()
    private lazy var minPriceFiled = UITextField()
    private lazy var maxPriceField = UITextField()
    private lazy var categoryLabel = UILabel()
    private lazy var searchButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureContext(context)
    }
    
    func configure(models: [Category], context: FilterContext?) {
        self.models = models
        self.context = context
    }
    
    private func configureContext(_ context: FilterContext?) {
        if let context = context {
            if let modelId = models.firstIndex(where: { $0.id == context.selectedCategory }) {
                categoryCollection.selectItem(
                    at: IndexPath(row: modelId, section: 0),
                    animated: false,
                    scrollPosition: .bottom
                )
            }
            if let minPrice = context.minPrice {
                minPriceFiled.text = String(minPrice)
            }
            if let maxPrice = context.maxPrice {
                maxPriceField.text = String(maxPrice)
            }
        }
    }
    
    @objc private func searchButtonTapped() {
        let minPrice = Int(minPriceFiled.text ?? "")
        let maxPrice = Int(maxPriceField.text ?? "")
        
        delegate?.setFilterContext(
            FilterContext(
                selectedCategory: selectedModel?.id,
                minPrice: minPrice,
                maxPrice: maxPrice
            )
        )
        dismiss(animated: true)
    }
    
    private func configureView() {
        view.backgroundColor = .primaryBackground
        
        priceLabel.text = "Price:"
        priceLabel.textColor = .contentColor
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneTapped))
        toolbar.setItems([doneButton], animated: false)
        
        for field in [minPriceFiled, maxPriceField] {
            field.keyboardType = .numberPad
            field.textColor = .contentColor
            field.returnKeyType = .done
            field.backgroundColor = .gray
            field.layer.cornerRadius = 8
            field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: field.frame.height))
            field.leftViewMode = .always
            field.inputAccessoryView = toolbar
        }
        minPriceFiled.attributedPlaceholder = NSAttributedString(
            string: "From",
            attributes: [.foregroundColor: UIColor.darkGray]
        )
        maxPriceField.attributedPlaceholder = NSAttributedString(
            string: "To",
            attributes: [.foregroundColor: UIColor.darkGray]
        )
        
        categoryLabel.text = "Categories:"
        categoryLabel.textColor = .contentColor
        categoryCollection = CategoryCollectionView(itemWidth: view.frame.width - 32)
        categoryCollection.setItems(models)
        categoryCollection.categoryFilterDelegate = self
        
        searchButton.setTitle("Search", for: .normal)
        searchButton.backgroundColor = .сontent
        searchButton.setTitleColor(.primaryBackground, for: .normal)
        searchButton.setTitleColor(.gray, for: .selected)
        searchButton.layer.cornerRadius = 16
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        for subview in [priceLabel, minPriceFiled, maxPriceField, categoryLabel, categoryCollection!, searchButton] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        configureConstraints()
    }
    
    @objc private func doneTapped() {
        minPriceFiled.resignFirstResponder()
        maxPriceField.resignFirstResponder()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            
            minPriceFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            minPriceFiled.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            minPriceFiled.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            minPriceFiled.heightAnchor.constraint(equalToConstant: 32),
            
            maxPriceField.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            maxPriceField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            maxPriceField.topAnchor.constraint(equalTo: minPriceFiled.topAnchor),
            maxPriceField.heightAnchor.constraint(equalTo: minPriceFiled.heightAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            categoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: minPriceFiled.bottomAnchor, constant: 16),
            
            categoryCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollection.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            categoryCollection.bottomAnchor.constraint(equalTo: searchButton.topAnchor),
            
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
    }
}

extension FilterBottomSheet: CategoryFilterDelegate {
    func categoryWasTapped(category: Category?) {
        self.selectedModel = category
    }
}
