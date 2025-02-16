import UIKit

struct PreviewProduct {
    let id: Int
    let title: String
    let price: Int
    let description: String
    let images: [String]
    let category: Category
    let previewImage: UIImage

    init(modelDTO: ProductDTO, image: UIImage, category: Category) {
        self.id = modelDTO.id
        self.title = modelDTO.title
        self.price = modelDTO.price
        self.description = modelDTO.description
        self.images = modelDTO.images
        self.category = category
        self.previewImage = image
    }
}
