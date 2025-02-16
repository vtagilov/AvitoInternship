import UIKit

final class ProductCardRouter: Router {
    weak var view: UIViewController?
    
    init(view: UIViewController) {
        self.view = view
    }
}
