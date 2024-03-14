// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: midtrans/clickstream/products/common/Payment.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

///platform="ios,android"

import Foundation
import SwiftProtobuf

public class Midtrans_Clickstream_Products_Common_Payment {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///MappedTo: "Payment Method Name"
  public var paymentMethodName: String = String()

  public var savedPayment: String = String()

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  required public init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Midtrans_Clickstream_Products_Common_Payment: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "midtrans.clickstream.products.common"

extension Midtrans_Clickstream_Products_Common_Payment: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".Payment"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "payment_method_name"),
    2: .standard(proto: "saved_payment"),
  ]

  public func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.paymentMethodName) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.savedPayment) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.paymentMethodName.isEmpty {
      try visitor.visitSingularStringField(value: self.paymentMethodName, fieldNumber: 1)
    }
    if !self.savedPayment.isEmpty {
      try visitor.visitSingularStringField(value: self.savedPayment, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public extension Midtrans_Clickstream_Products_Common_Payment {
         
    @objc public convenience init(properties: [String:Any],
         eventName: String) {

         self.init()
         
        if let paymentMethodName: String = properties["Payment Method Name"] as? String {
            self.paymentMethodName = paymentMethodName
        }
    }
}
