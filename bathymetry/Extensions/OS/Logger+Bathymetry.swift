import Foundation
import os

let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "org.kenzan8000.bathymetry", category: "bathymetry")

// MARK: - Logger + Bathymetry
extension Logger {
  
  // MARK: property
  
  var suffix: String {
    """
    
    --------------------------------------------------

    """
  }
  
  // MARK: public api
  
  /// Returns default prefix String
  /// - Parameters:
  ///   - file: file name
  ///   - function: function name
  /// - Returns: default prefix String
  func prefix(_ file: String = #fileID, _ function: String = #function) -> String {
    """
    
    [\(file)] \(function)
    --------------------------------------------------
    
    """
  }
}
