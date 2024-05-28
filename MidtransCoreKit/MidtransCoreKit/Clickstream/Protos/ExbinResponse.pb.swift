// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: midtrans/clickstream/products/common/ExbinResponse.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

///platform="ios,android"

import Foundation

public class Midtrans_Clickstream_Products_Common_ExbinResponse {
  //  Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var bank: String = String()

  public var bankCode: String = String()

  public var bin: String = String()

  public var binClass: String = String()

  public var binType: String = String()

  public var brand: String = String()

  public var channel: String = String()

  public var countryCode: String = String()

  public var countryName: String = String()

  public var registrationRequired: String = String()

  public var unknownFields =  UnknownStorage()

  required public init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Midtrans_Clickstream_Products_Common_ExbinResponse: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "midtrans.clickstream.products.common"

extension Midtrans_Clickstream_Products_Common_ExbinResponse:  Message,  _MessageImplementationBase,  _ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ExbinResponse"
  public static let _protobuf_nameMap:  _NameMap = [
    1: .same(proto: "bank"),
    2: .standard(proto: "bank_code"),
    3: .same(proto: "bin"),
    4: .standard(proto: "bin_class"),
    5: .standard(proto: "bin_type"),
    6: .same(proto: "brand"),
    7: .same(proto: "channel"),
    8: .standard(proto: "country_code"),
    9: .standard(proto: "country_name"),
    10: .standard(proto: "registration_required"),
  ]

  public func decodeMessage<D:  Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.bank) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.bankCode) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.bin) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.binClass) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.binType) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.brand) }()
      case 7: try { try decoder.decodeSingularStringField(value: &self.channel) }()
      case 8: try { try decoder.decodeSingularStringField(value: &self.countryCode) }()
      case 9: try { try decoder.decodeSingularStringField(value: &self.countryName) }()
      case 10: try { try decoder.decodeSingularStringField(value: &self.registrationRequired) }()
      default: break
      }
    }
  }

  public func traverse<V:  Visitor>(visitor: inout V) throws {
    if !self.bank.isEmpty {
      try visitor.visitSingularStringField(value: self.bank, fieldNumber: 1)
    }
    if !self.bankCode.isEmpty {
      try visitor.visitSingularStringField(value: self.bankCode, fieldNumber: 2)
    }
    if !self.bin.isEmpty {
      try visitor.visitSingularStringField(value: self.bin, fieldNumber: 3)
    }
    if !self.binClass.isEmpty {
      try visitor.visitSingularStringField(value: self.binClass, fieldNumber: 4)
    }
    if !self.binType.isEmpty {
      try visitor.visitSingularStringField(value: self.binType, fieldNumber: 5)
    }
    if !self.brand.isEmpty {
      try visitor.visitSingularStringField(value: self.brand, fieldNumber: 6)
    }
    if !self.channel.isEmpty {
      try visitor.visitSingularStringField(value: self.channel, fieldNumber: 7)
    }
    if !self.countryCode.isEmpty {
      try visitor.visitSingularStringField(value: self.countryCode, fieldNumber: 8)
    }
    if !self.countryName.isEmpty {
      try visitor.visitSingularStringField(value: self.countryName, fieldNumber: 9)
    }
    if !self.registrationRequired.isEmpty {
      try visitor.visitSingularStringField(value: self.registrationRequired, fieldNumber: 10)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public extension Midtrans_Clickstream_Products_Common_ExbinResponse {
         
    @objc public convenience init(properties: [String:Any],
         eventName: String) {

         self.init()
         
    }
}