import UIKit
import SwiftUI

// MARK: - BathymetryImage
struct BathymetryImage {
  let data: Data
  var uiImage: UIImage? { UIImage(data: data) }
  var image: Image? {
    guard let uiImage = uiImage else {
      return nil
    }
    return Image(uiImage: uiImage)
  }
}
