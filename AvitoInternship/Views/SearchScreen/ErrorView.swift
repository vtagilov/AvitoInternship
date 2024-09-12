//
//  ErrorView.swift
//  AvitoInternship
//
//  Created by Владимир on 12.09.2024.
//

import UIKit

final class ErrorView: UIView {
    
    var tryAgainAction: (() -> Void)?
    
    private lazy var tryAgainButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Попробовать снова", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(tryAgainButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Нет интернета"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tryAgainButtonTapped() {
        isHidden = true
        tryAgainAction?()
    }
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        backgroundColor = .gray
        layer.cornerRadius = 8
        clipsToBounds = true
        
        for subview in [tryAgainButton, label] {
            addSubview(subview)
        }
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            
            tryAgainButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            tryAgainButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            tryAgainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
