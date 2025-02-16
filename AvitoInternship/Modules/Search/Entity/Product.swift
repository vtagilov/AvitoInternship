import UIKit

struct Product {
    let id: Int
    let title: String
    let price: Int
    let description: String
    let category: Category
    let images: [UIImage]

    init(previewProduct: PreviewProduct, images: [UIImage]) {
        self.id = previewProduct.id
        self.title = previewProduct.title
        self.price = previewProduct.price
        self.description = previewProduct.description
        self.category = previewProduct.category
        self.images = [previewProduct.previewImage] + images
    }
}
