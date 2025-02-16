import UIKit

struct Category {
    let id: Int
    let name: String

    init(modelDTO: CategoryDTO) {
        self.id = modelDTO.id
        self.name = modelDTO.name
    }
}
