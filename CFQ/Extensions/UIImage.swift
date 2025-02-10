
import UIKit

extension UIImage {
    /// Transforme image in Circle or black circle
    static func roundedImage(named imageName: String?, size: CGSize, backgroundColor: UIColor = .white, borderWidth: CGFloat = 5, borderColor: UIColor = .black) -> UIImage? {
        if let imageName = imageName, let image = UIImage(named: imageName) {
            return image.createRoundedImage(size: size, backgroundColor: backgroundColor, borderWidth: borderWidth, borderColor: borderColor)
        } else {
            return createDefaultCircle(size: size)
        }
    }
    
    /// Generates a round image with a background and border
    private func createRoundedImage(size: CGSize, backgroundColor: UIColor, borderWidth: CGFloat, borderColor: UIColor) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)
            let circlePath = UIBezierPath(ovalIn: rect)
            
            // draw circle
            backgroundColor.setFill()
            circlePath.fill()

            
            // Draw stroke
            if borderWidth > 0 {
                borderColor.setStroke()
                circlePath.lineWidth = borderWidth
                circlePath.stroke()
            }
             

            // Resize and crop image to circle
            if let resizedImage = self.cropToCircle()?.resizeImage(targetSize: CGSize(width: size.width * 0.8, height: size.height * 0.8)) {
                let imageRect = CGRect(
                    x: (size.width - resizedImage.size.width) / 2,
                    y: (size.height - resizedImage.size.height) / 2,
                    width: resizedImage.size.width,
                    height: resizedImage.size.height
                )
                resizedImage.draw(in: imageRect)
            }
        }
    }

    /// Crop an image into a perfect circle
    private func cropToCircle() -> UIImage? {
        let minSide = min(size.width, size.height)
        let imageSize = CGSize(width: minSide, height: minSide)

        let renderer = UIGraphicsImageRenderer(size: imageSize)
        return renderer.image { _ in
            let rect = CGRect(origin: .zero, size: imageSize)
            UIBezierPath(ovalIn: rect).addClip()
            self.draw(in: rect)
        }
    }

    /// Resize picture
    private func resizeImage(targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    /// Creates a black circle by default if no image is provided
    private static func createDefaultCircle(size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)
            let circlePath = UIBezierPath(ovalIn: rect)
            
            // Dessiner un cercle noir
            UIColor.black.setFill()
            circlePath.fill()
        }
    }
}
