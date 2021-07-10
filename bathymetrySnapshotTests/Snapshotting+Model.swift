import SnapshotTesting
import UIKit

// MARK: - Snapshotting (UIViewController) + Model
extension Snapshotting where Value == UIViewController, Format == UIImage {
  public static func img(
    precision: Float = 1,
    size: CGSize? = nil,
    orientation: ViewImageConfig.Orientation = .portrait
  ) -> Snapshotting {
    .image(
      on: model.config(orientation),
      precision: precision,
      size: size,
      traits: model.traits(orientation)
    )
  }
}

// MARK: - Snapshotting (UIView) + Model
extension Snapshotting where Value == UIView, Format == UIImage {
  public static func img(
    precision: Float = 1,
    orientation: ViewImageConfig.Orientation = .portrait
  ) -> Snapshotting {
    .image(
      precision: precision,
      traits: model.traits(orientation)
    )
  }
}

// MARK: - ViewImageConfig + Model
extension ViewImageConfig {
  public static let iPhone12ProMax = ViewImageConfig.iPhone12ProMax(.portrait)
  public static func iPhone12ProMax(_ orientation: Orientation) -> ViewImageConfig {
    let safeArea: UIEdgeInsets
    let size: CGSize
    switch orientation {
    case .landscape:
      safeArea = .init(top: 0, left: 47, bottom: 21, right: 47)
      size = .init(width: 926, height: 428)
    case .portrait:
      safeArea = .init(top: 47, left: 0, bottom: 34, right: 0)
      size = .init(width: 428, height: 926)
    }
    return .init(safeArea: safeArea, size: size, traits: .iPhone12ProMax(orientation))
  }
}

// MARK: - UITraitCollection + Model
extension UITraitCollection {
  public static func iPhone12ProMax(_ orientation: ViewImageConfig.Orientation)
   -> UITraitCollection {
     let base: [UITraitCollection] = [
       //    .init(displayGamut: .P3),
       //    .init(displayScale: 3),
       .init(forceTouchCapability: .available),
       .init(layoutDirection: .leftToRight),
       .init(preferredContentSizeCategory: .medium),
       .init(userInterfaceIdiom: .phone)
     ]
     switch orientation {
     case .landscape:
       return .init(
         traitsFrom: base + [
           .init(horizontalSizeClass: .regular),
           .init(verticalSizeClass: .compact)
         ]
       )
     case .portrait:
       return .init(
         traitsFrom: base + [
           .init(horizontalSizeClass: .compact),
           .init(verticalSizeClass: .regular)
         ]
       )
     }
   }
}

// MARK: - Model
enum Model {
  case iPhoneSe
  case iPhone12ProMax
  case unknown
  
  func config(_ orientation: ViewImageConfig.Orientation = .portrait) -> ViewImageConfig {
    switch self {
    case .iPhoneSe:
      return .iPhoneSe
    case .iPhone12ProMax:
      return .iPhone12ProMax
    case .unknown:
      return .init()
    }
  }
  
  func traits(_ orientation: ViewImageConfig.Orientation = .portrait) -> UITraitCollection {
    switch self {
    case .iPhoneSe:
      return .iPhoneSe(orientation)
    case .iPhone12ProMax:
      return .iPhone12ProMax(orientation)
    case .unknown:
      return .init()
    }
  }
  
  var name: String {
    String(describing: self)
  }
  
  var width: CGFloat {
    switch self {
    case .iPhoneSe:
      return 320
    case .iPhone12ProMax:
      return 428
    case .unknown:
      return 0
    }
  }
  
  var height: CGFloat {
    switch self {
    case .iPhoneSe:
      return 568
    case .iPhone12ProMax:
      return 926
    case .unknown:
      return 0
    }
  }
  
  var size: CGSize {
    CGSize(width: width, height: height)
  }
}

var model: Model = {
  var systemInfo = utsname()
  uname(&systemInfo)
  let machineMirror = Mirror(reflecting: systemInfo.machine)
  let identifier = machineMirror.children.reduce("") { identifier, element in
    guard let value = element.value as? Int8, value != 0 else { return identifier }
    return identifier + String(UnicodeScalar(UInt8(value)))
  }
  func mapToDevice(identifier: String) -> String {
    switch identifier {
    case "iPod9,1":
      return "iPod touch (7th generation)"
    case "iPhone13,4":
      return "iPhone 12 Pro Max"
    case "i386", "x86_64":
      return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
    default:
      return identifier
    }
  }
  let modelName = mapToDevice(identifier: identifier)
  if modelName.hasSuffix("iPod touch (7th generation)") {
    return .iPhoneSe
  } else if modelName.hasSuffix("iPhone 12 Pro Max") {
    return .iPhone12ProMax
  } else {
    return .unknown
  }
}()
