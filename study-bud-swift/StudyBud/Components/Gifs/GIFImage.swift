//
//  GIFImage.swift
//  StudyBud
//
//  Created by Ayana Griffin on 6/2/25.
//

import SwiftUI

struct GIFImage: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        
        if let animated = UIImage.animatedImageWithGIF(named: gifName) {
            print("found")
            imageView.image = animated
        } else {
            print("fallback")
            imageView.image = UIImage(named: gifName)
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        // Add these constraints to ensure it respects SwiftUI frame
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        // Nothing dynamic to update once set. UIImageView will loop automatically.
    }
}
