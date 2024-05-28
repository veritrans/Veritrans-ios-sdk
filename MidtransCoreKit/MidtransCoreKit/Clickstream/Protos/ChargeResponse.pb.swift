// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: midtrans/clickstream/products/common/ChargeResponse.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

///platform="ios,android"

import Foundation

public class Midtrans_Clickstream_Products_Common_ChargeResponse {
  //  Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var transactionID: String = String()

  public var orderID: String = String()

  public var bank: String = String()

  public var channelResponseCode: String = String()

  public var channelResponseMessage: String = String()

  public var transactionStatus: String = String()

  public var fraudStatus: String = String()

  public var currency: String = String()

  public var cardType: String = String()

  public var version3Ds: String = String()

  public var paymentType: String = String()

  public var chargerType: String = String()

  public var unknownFields =  UnknownStorage()

  required public init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Midtrans_Clickstream_Products_Common_ChargeResponse: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "midtrans.clickstream.products.common"

extension Midtrans_Clickstream_Products_Common_ChargeResponse:  Message,  _MessageImplementationBase,  _ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ChargeResponse"
  public static let _protobuf_nameMap:  _NameMap = [
    1: .standard(proto: "transaction_id"),
    2: .standard(proto: "order_id"),
    3: .same(proto: "bank"),
    4: .standard(proto: "channel_response_code"),
    5: .standard(proto: "channel_response_message"),
    6: .standard(proto: "transaction_status"),
    7: .standard(proto: "fraud_status"),
    8: .same(proto: "currency"),
    9: .standard(proto: "card_type"),
    10: .standard(proto: "version_3ds"),
    11: .standard(proto: "payment_type"),
    12: .standard(proto: "charger_type"),
  ]

  public func decodeMessage<D:  Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.transactionID) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.orderID) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.bank) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.channelResponseCode) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.channelResponseMessage) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.transactionStatus) }()
      case 7: try { try decoder.decodeSingularStringField(value: &self.fraudStatus) }()
      case 8: try { try decoder.decodeSingularStringField(value: &self.currency) }()
      case 9: try { try decoder.decodeSingularStringField(value: &self.cardType) }()
      case 10: try { try decoder.decodeSingularStringField(value: &self.version3Ds) }()
      case 11: try { try decoder.decodeSingularStringField(value: &self.paymentType) }()
      case 12: try { try decoder.decodeSingularStringField(value: &self.chargerType) }()
      default: break
      }
    }
  }

  public func traverse<V:  Visitor>(visitor: inout V) throws {
    if !self.transactionID.isEmpty {
      try visitor.visitSingularStringField(value: self.transactionID, fieldNumber: 1)
    }
    if !self.orderID.isEmpty {
      try visitor.visitSingularStringField(value: self.orderID, fieldNumber: 2)
    }
    if !self.bank.isEmpty {
      try visitor.visitSingularStringField(value: self.bank, fieldNumber: 3)
    }
    if !self.channelResponseCode.isEmpty {
      try visitor.visitSingularStringField(value: self.channelResponseCode, fieldNumber: 4)
    }
    if !self.channelResponseMessage.isEmpty {
      try visitor.visitSingularStringField(value: self.channelResponseMessage, fieldNumber: 5)
    }
    if !self.transactionStatus.isEmpty {
      try visitor.visitSingularStringField(value: self.transactionStatus, fieldNumber: 6)
    }
    if !self.fraudStatus.isEmpty {
      try visitor.visitSingularStringField(value: self.fraudStatus, fieldNumber: 7)
    }
    if !self.currency.isEmpty {
      try visitor.visitSingularStringField(value: self.currency, fieldNumber: 8)
    }
    if !self.cardType.isEmpty {
      try visitor.visitSingularStringField(value: self.cardType, fieldNumber: 9)
    }
    if !self.version3Ds.isEmpty {
      try visitor.visitSingularStringField(value: self.version3Ds, fieldNumber: 10)
    }
    if !self.paymentType.isEmpty {
      try visitor.visitSingularStringField(value: self.paymentType, fieldNumber: 11)
    }
    if !self.chargerType.isEmpty {
      try visitor.visitSingularStringField(value: self.chargerType, fieldNumber: 12)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public extension Midtrans_Clickstream_Products_Common_ChargeResponse {
         
    @objc public convenience init(properties: [String:Any],
         eventName: String) {

         self.init()
         
    }
}
