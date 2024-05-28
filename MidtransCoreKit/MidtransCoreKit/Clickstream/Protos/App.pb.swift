// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: midtrans/clickstream/meta/App.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

///platform="ios,android"

import Foundation

public class Midtrans_Clickstream_Meta_App {
  //  Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///snapSDK
  public var appName: String = String()

  public var sdkVersion: String = String()

  ///sdkflow or UIFlow
  public var sdkFlowType: String = String()

  /// mobile-ios mobile-android
  public var sourceType: String = String()

  public var merchantURL: String = String()

  public var colourScheme: String = String()

  public var stepNumber: String = String()

  public var allowRetry: Bool = false

  public var unknownFields =  UnknownStorage()

  required public init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Midtrans_Clickstream_Meta_App: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "midtrans.clickstream.meta"

extension Midtrans_Clickstream_Meta_App:  Message,  _MessageImplementationBase,  _ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".App"
  public static let _protobuf_nameMap:  _NameMap = [
    1: .standard(proto: "app_name"),
    2: .standard(proto: "sdk_version"),
    3: .standard(proto: "sdk_flow_type"),
    4: .standard(proto: "source_type"),
    5: .standard(proto: "merchant_url"),
    6: .standard(proto: "colour_scheme"),
    7: .standard(proto: "step_number"),
    8: .standard(proto: "allow_retry"),
  ]

  public func decodeMessage<D:  Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.appName) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.sdkVersion) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.sdkFlowType) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.sourceType) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.merchantURL) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.colourScheme) }()
      case 7: try { try decoder.decodeSingularStringField(value: &self.stepNumber) }()
      case 8: try { try decoder.decodeSingularBoolField(value: &self.allowRetry) }()
      default: break
      }
    }
  }

  public func traverse<V:  Visitor>(visitor: inout V) throws {
    if !self.appName.isEmpty {
      try visitor.visitSingularStringField(value: self.appName, fieldNumber: 1)
    }
    if !self.sdkVersion.isEmpty {
      try visitor.visitSingularStringField(value: self.sdkVersion, fieldNumber: 2)
    }
    if !self.sdkFlowType.isEmpty {
      try visitor.visitSingularStringField(value: self.sdkFlowType, fieldNumber: 3)
    }
    if !self.sourceType.isEmpty {
      try visitor.visitSingularStringField(value: self.sourceType, fieldNumber: 4)
    }
    if !self.merchantURL.isEmpty {
      try visitor.visitSingularStringField(value: self.merchantURL, fieldNumber: 5)
    }
    if !self.colourScheme.isEmpty {
      try visitor.visitSingularStringField(value: self.colourScheme, fieldNumber: 6)
    }
    if !self.stepNumber.isEmpty {
      try visitor.visitSingularStringField(value: self.stepNumber, fieldNumber: 7)
    }
    if self.allowRetry != false {
      try visitor.visitSingularBoolField(value: self.allowRetry, fieldNumber: 8)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public extension Midtrans_Clickstream_Meta_App {
         
    @objc public convenience init(properties: [String:Any],
         eventName: String) {

         self.init()
         
    }
}