import UIKit

struct Category {
    let id: Int
    let name: String
    let image: UIImage

    init(modelDTO: CategoryDTO, image: UIImage) {
        self.id = modelDTO.id
        self.name = modelDTO.name
        self.image = image
    }
    
    private init() {
        self.id = -1
        self.name = ""
        self.image = UIImage()
    }
    
    static let unknown = Category()
}
