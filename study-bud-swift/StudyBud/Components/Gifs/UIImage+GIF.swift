// UIImage+GIF.swift
import UIKit
import ImageIO

extension UIImage {
    /// Create an animated UIImage from GIF data
    public class func animatedImageWithGIF(named name: String) -> UIImage? {
        guard
            let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif"),
            let data = try? Data(contentsOf: bundleURL)
        else {
            print("returning nil")
            return nil
        }
        return animatedImageWithGIFData(data)
    }

    /// Decode GIF data into an animated UIImage
    public class func animatedImageWithGIFData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("returning nil 2")
            return nil }
        let count = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        var totalDuration: Double = 0

        for i in 0..<count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            let frameDuration = UIImage.frameDuration(at: i, source: source)
            totalDuration += frameDuration
            images.append(UIImage(cgImage: cgImage))
        }
        guard !images.isEmpty else {
            print("returning nil 3")
            return nil
        }
        return UIImage.animatedImage(with: images, duration: totalDuration)
    }

    private class func frameDuration(at index: Int, source: CGImageSource) -> Double {
        var frameDuration: Double = 0.1
        if let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
           let gifProps = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any]
        {
            if let unclamped = gifProps[kCGImagePropertyGIFUnclampedDelayTime] as? Double, unclamped > 0 {
                frameDuration = unclamped
            } else if let delay = gifProps[kCGImagePropertyGIFDelayTime] as? Double, delay > 0 {
                frameDuration = delay
            }
        }
        if frameDuration < 0.011 {
            frameDuration = 0.1
        }
        return frameDuration
    }
}
