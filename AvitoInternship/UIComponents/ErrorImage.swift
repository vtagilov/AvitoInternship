import UIKit

extension UIImage {
    static let errorImage: UIImage = {
        createImageWithSymbol(
            backgroundColor: .gray,
            symbolName: "exclamationmark.circle.fill",
            symbolSize: 30
        ) ?? UIImage()
    }()
    
 
    static func createImageWithSymbol(backgroundColor: UIColor, symbolName: String, symbolSize: CGFloat) -> UIImage? {
        let size = CGSize(width: symbolSize * 2, height: symbolSize * 2)

        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            backgroundColor.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            let symbolConfig = UIImage.SymbolConfiguration(pointSize: symbolSize, weight: .bold)
            if let symbolImage = UIImage(systemName: symbolName, withConfiguration: symbolConfig) {
                symbolImage.draw(
                    in: CGRect(
                        x: (size.width - symbolSize) / 2,
                        y: (size.height - symbolSize) / 2,
                        width: symbolSize,
                        height: symbolSize
                    )
                )
            }
        }
    }

}
