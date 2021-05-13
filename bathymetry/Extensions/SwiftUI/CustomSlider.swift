import SwiftUI

// MARK: - CustomSlider
struct CustomSlider: UIViewRepresentable {
  
  // MARK: property

  @Binding var value: Double
  var `in` = 0.0...1.0
  var minimumTrackTintColor: Color?
  var maximumTrackTintColor: Color?
  var backgroundColor: Color?
  var thumbTintColor: Color?
  var thumbImage: UIImage?
  var highlightedThumbImage: UIImage?
  var thresholdValue: Double?
  var thresholdSecond: TimeInterval?

  // MARK: UIViewRepresentable
  
  func makeUIView(context: Context) -> UISlider {
    let slider = UISlider(frame: .zero)
    if let thumbTintColor = thumbTintColor {
      slider.thumbTintColor = UIColor(thumbTintColor)
    }
    if let minimumTrackTintColor = minimumTrackTintColor {
      slider.minimumTrackTintColor = UIColor(minimumTrackTintColor)
    }
    if let maximumTrackTintColor = maximumTrackTintColor {
      slider.maximumTrackTintColor = UIColor(maximumTrackTintColor)
    }
    if let minimumTrackTintColor = minimumTrackTintColor {
      slider.minimumTrackTintColor = UIColor(minimumTrackTintColor)
    }
    if let maximumTrackTintColor = maximumTrackTintColor {
      slider.maximumTrackTintColor = UIColor(maximumTrackTintColor)
    }
    slider.maximumValue = Float(self.in.upperBound)
    slider.minimumValue = Float(self.in.lowerBound)
    slider.value = Float(value)
    slider.setThumbImage(thumbImage, for: .normal)
    slider.setThumbImage(highlightedThumbImage, for: .highlighted)

    slider.addTarget(
      context.coordinator,
      action: #selector(Coordinator.valueChanged(_:)),
      for: .valueChanged
    )
    return slider
  }
  
  func updateUIView(_ uiView: UISlider, context: Context) {
    uiView.value = Float(value)
  }

  func makeCoordinator() -> CustomSlider.Coordinator {
    Coordinator(value: $value, thresholdValue: thresholdValue ?? 0.0, thresholdSecond: thresholdSecond ?? 0.0)
  }

  // MARK: Coordinator
  
  final class Coordinator: NSObject {
    var value: Binding<Double>
    var second: TimeInterval
    var thresholdValue: Double
    var thresholdSecond: TimeInterval
    
    init(value: Binding<Double>, second: TimeInterval = Date().timeIntervalSince1970, thresholdValue: Double = 0.0, thresholdSecond: TimeInterval = 0.0) {
      self.value = value
      self.second = second
      self.thresholdValue = thresholdValue
      self.thresholdSecond = thresholdSecond
    }
    
    @objc
    func valueChanged(_ sender: UISlider) {
      let now = Date()
      if abs(value.wrappedValue - Double(sender.value)) > thresholdValue && abs(now.timeIntervalSince1970 - second) > thresholdSecond {
        value.wrappedValue = Double(sender.value)
        second = now.timeIntervalSince1970
      }
    }
  }
}

// MARK: - CustomSlider_Previews
struct CustomSlider_Previews: PreviewProvider {
  static var previews: some View {
    CustomSlider(
      value: .constant(0.5)
    )
  }
}
