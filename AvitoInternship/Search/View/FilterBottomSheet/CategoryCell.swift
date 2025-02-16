import UIKit

final class CategoryCell: UICollectionViewCell, BaseCollectionCell {
    static var reuseIdentifier: String = "CategoryCell"
    
    private var model: Category?
    private lazy var titleLabel = UILabel(frame: .zero)
    private lazy var backView = UIView()
    
    override var isSelected: Bool {
        didSet {
            let temp = backView.backgroundColor
            backView.backgroundColor = titleLabel.textColor
            titleLabel.textColor = temp
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(model: Category) {
        self.model = model
        titleLabel.text = model.name
    }
    
    private func configureView() {
        backView.backgroundColor = .primaryBackground
        backView.layer.cornerRadius = 4
        backView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backView)
        
        backView.addSubview(titleLabel)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .contentColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -4),
            
            backView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -2),
            backView.trailingAnchor.constraint(lessThanOrEqualTo: titleLabel.trailingAnchor, constant: 2),
            backView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -2),
            backView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2)
        ])
    }
}
