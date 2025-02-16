import UIKit

final class SearchRouter: Router {
    weak var view: UIViewController?
    weak var filterDelegate: FilterBottomSheetDelegate?
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func showFilerBottomSheet(categories: [Category], filters: FilterContext?) {
        let bottomSheet = FilterBottomSheet()
        bottomSheet.delegate = filterDelegate
        bottomSheet.configure(models: categories, context: filters)
        bottomSheet.modalPresentationStyle = .pageSheet
        if let sheet = bottomSheet.sheetPresentationController {
            sheet.detents = [.medium(), .medium()]
        }
        view?.present(bottomSheet, animated: true)
    }
}
