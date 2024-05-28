// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: midtrans/clickstream/products/common/ChargeParams.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

///platform="ios,android"

import Foundation

public class Midtrans_Clickstream_Products_Common_ChargeParams {
  //  Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var lastPaymentMethodName: String = String()

  public var lastStatusCode: String = String()

  public var paymentMethodName: String = String()

  public var grossAmount: String = String()

  public var orderID: String = String()

  public var saveCard: String = String()

  public var selectedInstallmentBank: String = String()

  public var selectedInstallmentTerm: String = String()

  public var selectedMinimumAmountBank: String = String()

  public var promoID: String = String()

  public var promoName: String = String()

  public var promoAmount: String = String()

  public var creditCardPoint: String = String()

  public var unknownFields =  UnknownStorage()

  required public init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Midtrans_Clickstream_Products_Common_ChargeParams: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "midtrans.clickstream.products.common"

extension Midtrans_Clickstream_Products_Common_ChargeParams:  Message,  _MessageImplementationBase,  _ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ChargeParams"
  public static let _protobuf_nameMap:  _NameMap = [
    1: .standard(proto: "last_payment_method_name"),
    2: .standard(proto: "last_status_code"),
    3: .standard(proto: "payment_method_name"),
    4: .standard(proto: "gross_amount"),
    5: .standard(proto: "order_id"),
    6: .standard(proto: "save_card"),
    7: .standard(proto: "selected_installment_bank"),
    8: .standard(proto: "selected_installment_term"),
    9: .standard(proto: "selected_minimum_amount_bank"),
    10: .standard(proto: "promo_id"),
    11: .standard(proto: "promo_name"),
    12: .standard(proto: "promo_amount"),
    13: .standard(proto: "credit_card_point"),
  ]

  public func decodeMessage<D:  Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.lastPaymentMethodName) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.lastStatusCode) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.paymentMethodName) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.grossAmount) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.orderID) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.saveCard) }()
      case 7: try { try decoder.decodeSingularStringField(value: &self.selectedInstallmentBank) }()
      case 8: try { try decoder.decodeSingularStringField(value: &self.selectedInstallmentTerm) }()
      case 9: try { try decoder.decodeSingularStringField(value: &self.selectedMinimumAmountBank) }()
      case 10: try { try decoder.decodeSingularStringField(value: &self.promoID) }()
      case 11: try { try decoder.decodeSingularStringField(value: &self.promoName) }()
      case 12: try { try decoder.decodeSingularStringField(value: &self.promoAmount) }()
      case 13: try { try decoder.decodeSingularStringField(value: &self.creditCardPoint) }()
      default: break
      }
    }
  }

  public func traverse<V:  Visitor>(visitor: inout V) throws {
    if !self.lastPaymentMethodName.isEmpty {
      try visitor.visitSingularStringField(value: self.lastPaymentMethodName, fieldNumber: 1)
    }
    if !self.lastStatusCode.isEmpty {
      try visitor.visitSingularStringField(value: self.lastStatusCode, fieldNumber: 2)
    }
    if !self.paymentMethodName.isEmpty {
      try visitor.visitSingularStringField(value: self.paymentMethodName, fieldNumber: 3)
    }
    if !self.grossAmount.isEmpty {
      try visitor.visitSingularStringField(value: self.grossAmount, fieldNumber: 4)
    }
    if !self.orderID.isEmpty {
      try visitor.visitSingularStringField(value: self.orderID, fieldNumber: 5)
    }
    if !self.saveCard.isEmpty {
      try visitor.visitSingularStringField(value: self.saveCard, fieldNumber: 6)
    }
    if !self.selectedInstallmentBank.isEmpty {
      try visitor.visitSingularStringField(value: self.selectedInstallmentBank, fieldNumber: 7)
    }
    if !self.selectedInstallmentTerm.isEmpty {
      try visitor.visitSingularStringField(value: self.selectedInstallmentTerm, fieldNumber: 8)
    }
    if !self.selectedMinimumAmountBank.isEmpty {
      try visitor.visitSingularStringField(value: self.selectedMinimumAmountBank, fieldNumber: 9)
    }
    if !self.promoID.isEmpty {
      try visitor.visitSingularStringField(value: self.promoID, fieldNumber: 10)
    }
    if !self.promoName.isEmpty {
      try visitor.visitSingularStringField(value: self.promoName, fieldNumber: 11)
    }
    if !self.promoAmount.isEmpty {
      try visitor.visitSingularStringField(value: self.promoAmount, fieldNumber: 12)
    }
    if !self.creditCardPoint.isEmpty {
      try visitor.visitSingularStringField(value: self.creditCardPoint, fieldNumber: 13)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public extension Midtrans_Clickstream_Products_Common_ChargeParams {
         
    @objc public convenience init(properties: [String:Any],
         eventName: String) {

         self.init()
         
    }
}