//
//  DetailViewController.swift
//  AvitoInternship
//
//  Created by Владимир on 12.09.2024.
//

import UIKit

final class DetailViewController: UIViewController {
    private let viewModel = DetailViewModel()
    
    private let errorView = ErrorView()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicatior = UIActivityIndicatorView(frame: .zero)
        indicatior.style = .large
        indicatior.hidesWhenStopped = true
        indicatior.startAnimating()
        indicatior.translatesAutoresizingMaskIntoConstraints = false
        return indicatior
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.addTarget(self, action: #selector(shareImageButtonAction), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewModel()
        configureErorView()
    }
    
    func configure(_ model: SearchModel) {
        viewModel.performImageDataRequest(model.fullImageUrl)
        descriptionLabel.attributedText = String.createLabelPost(user: model.username, text: model.description)
        createdLabel.text = model.createdDate
    }
    
    private func configureViewModel() {
        viewModel.failureAction = { error in
            DispatchQueue.main.async {
                self.errorView.isHidden = false
                print("ERROR: ", error)
            }
        }
        viewModel.stopLoadingAction = {
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
            }
        }
        viewModel.resultAction = { imageData in
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
            }
        }
    }
    
    private func configureErorView() {
        errorView.tryAgainAction = {
            self.viewModel.tryMakeRequestsAgain()
        }
    }
    
    @objc private func shareImageButtonAction() {
        guard let image = imageView.image else { return }
        let items = [image]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @objc private func saveButtonAction() {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .black
        for subview in [scrollView, descriptionLabel, createdLabel, loadingIndicator, shareButton, saveButton, errorView] {
            view.addSubview(subview)
        }
        scrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalTo: loadingIndicator.widthAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -10),
            
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            descriptionLabel.bottomAnchor.constraint(equalTo: createdLabel.topAnchor, constant: -5),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            
            createdLabel.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -5),
            createdLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            createdLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.widthAnchor.constraint(equalTo: saveButton.heightAnchor, multiplier: 1.0),
            saveButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -25),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.widthAnchor.constraint(equalTo: shareButton.heightAnchor, multiplier: 1.0),
            shareButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 25),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.75),
            errorView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.5),
        ])
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
