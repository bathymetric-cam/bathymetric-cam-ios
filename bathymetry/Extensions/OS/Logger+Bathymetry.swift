import Foundation
import os

let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "org.kenzan8000.bathymetry", category: "bathymetry")

// MARK: - Logger + Bathymetry
extension Logger {
  func prefix(_ instance: String = #file, _ function: String = #function) -> String {
    """
    
    [file] \(String(describing: type(of: instance)))
    [func] \(function)
    --------------------------------------------------
    
    """
  }
}
