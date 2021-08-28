import Foundation

// MARK: - URLSession.DataTaskPublisher+StatusCode.swift
extension URLSession.DataTaskPublisher {
  func validate<S: Sequence>(statusCode range: S) -> Self where S.Iterator.Element == Int {
    tryMap { data, response -> Data in
      switch (response as? HTTPURLResponse)?.statusCode {
      case .some(let code) where range.contains(code):
        return data
      case .some(let code) where !range.contains(code):
        throw URLError(URLError.Code(rawValue: code))
      default:
        throw URLError(URLError.Code(rawValue: 400))
      }
    }.upstream
  }
}
