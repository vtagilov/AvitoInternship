import UIKit
import Foundation

protocol ProductCardPresenter: Presenter {
    var view: ProductCardView? { get set }
    var router: ProductCardRouter? { get set }
    
    func showImage(_ image: UIImage)
}

final class ProductCardPresenterImpl: ProductCardPresenter {
    weak var view: ProductCardView?
    var router: ProductCardRouter?
    
    private let interactor: ProductCardInteractor
    
    private let previewProduct: PreviewProduct
    
    init(interactor: ProductCardInteractor, previewProduct: PreviewProduct) {
        self.interactor = interactor
        self.previewProduct = previewProduct
        interactor.fetchImages(urls: previewProduct.images)
    }
    
    func showImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak view] in
            view?.appendImage(image)
        }
    }
}
