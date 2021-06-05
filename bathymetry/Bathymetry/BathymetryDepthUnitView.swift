import SwiftUI

// MARK: - BathymetryDepthUnitView
struct BathymetryDepthUnitView: View {
  
  // MARK: property
  
  @Binding var depthUnit: BathymetryDepthUnit
  @State private var actionSheet = false
  
  var body: some View {
    HStack {
      Text("Depth Unit: ")
      
      Button(
        action: {
          actionSheet.toggle()
        },
        label: {
          Text(depthUnit.unit)
        }
      )
    }
    .actionSheet(
      isPresented: $actionSheet
    ) {
      ActionSheet(
        title: Text("Depth Unit"),
        buttons: [
          .default(Text(BathymetryDepthUnit.meter.unit)) {
            depthUnit = .meter
            actionSheet.toggle()
          },
          .default(Text(BathymetryDepthUnit.feet.unit)) {
            depthUnit = .feet
            actionSheet.toggle()
          },
          .cancel { actionSheet.toggle() }
        ]
      )
    }
  }
}

// MARK: - BathymetryDepthUnitView_Previews
struct BathymetryDepthUnitView_Previews: PreviewProvider {
  static var previews: some View {
    BathymetryDepthUnitView(
      depthUnit: Binding<BathymetryDepthUnit>(
        get: { .meter },
        set: { _ in }
      )
    )
  }
}
