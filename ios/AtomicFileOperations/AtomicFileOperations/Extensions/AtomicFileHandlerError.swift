import Foundation

extension AtomicFileHandler.AtomicFileHandlerError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .badEncoding:
      return NSLocalizedString("Bad Encoding:  Please enter Unicode (.utf8), ASCII (.ascii), or Base64 (.base64).", comment: "")
    case .badFileName:
      return NSLocalizedString("Bad File Name:  Please enter a valid file name.", comment: "")
    }
  }
}
