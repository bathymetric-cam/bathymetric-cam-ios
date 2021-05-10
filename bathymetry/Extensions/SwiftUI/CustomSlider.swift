import SwiftUI

// MARK: - CustomSlider
struct CustomSlider: UIViewRepresentable {
  
  // MARK: property

  @Binding var value: Double
  var `in` = 0.0...1.0
  var tintColor: Color?
  var thumbTintColor: Color?
  var thumbImage: UIImage?
  var highlightedThumbImage: UIImage?
  var minimumTrackTintColor: Color?
  var maximumTrackTintColor: Color?

  // MARK: UIViewRepresentable
  
  func makeUIView(context: Context) -> UISlider {
    let slider = UISlider(frame: .zero)
    if let thumbTintColor = thumbTintColor {
      slider.thumbTintColor = UIColor(thumbTintColor)
    }
    if let tintColor = tintColor {
      slider.tintColor = UIColor(tintColor)
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
    uiView.value = Float(self.value)
  }

  func makeCoordinator() -> CustomSlider.Coordinator {
    Coordinator(value: $value)
  }

  // MARK: Coordinator
  
  final class Coordinator: NSObject {
    var value: Binding<Double>
    
    init(value: Binding<Double>) {
      self.value = value
    }
    
    @objc
    func valueChanged(_ sender: UISlider) {
      value.wrappedValue = Double(sender.value)
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
