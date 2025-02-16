import UIKit

protocol ErrorViewDelegate: AnyObject {
    func retryButtonTapped()
}

final class ErrorView: UIView {
    
    weak var delegate: ErrorViewDelegate?
    
    private lazy var label = UILabel(frame: .zero)
    private lazy var retryButton = UIButton(frame: .zero)
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(type: ErrorViewType) {
        switch type {
        case .networkError:
            label.text = "Some network error"
        }
    }
    
    private func configureView() {
        for subview in [label, retryButton] {
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        label.text = "Ошибка сети"
        label.tintColor = .contentColor
        
        retryButton.setTitle("Повторить попытку", for: .normal)
        retryButton.setTitleColor(.contentColor, for: .normal)
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: centerYAnchor),
            
            retryButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            retryButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            retryButton.topAnchor.constraint(equalTo: centerYAnchor),
            retryButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func retryButtonTapped() {
        delegate?.retryButtonTapped()
    }
}
