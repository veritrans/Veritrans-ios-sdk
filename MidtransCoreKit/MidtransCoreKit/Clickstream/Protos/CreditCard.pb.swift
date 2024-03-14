// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: midtrans/clickstream/meta/CreditCard.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

///platform="ios,android"

import Foundation
import SwiftProtobuf

public class Midtrans_Clickstream_Meta_CreditCard {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var savedTokensNumber: UInt32 {
    get {return _storage._savedTokensNumber}
    set {_uniqueStorage()._savedTokensNumber = newValue}
  }

  public var secure: Bool {
    get {return _storage._secure}
    set {_uniqueStorage()._secure = newValue}
  }

  public var saveCard: Bool {
    get {return _storage._saveCard}
    set {_uniqueStorage()._saveCard = newValue}
  }

  public var merchantSaveCard: Bool {
    get {return _storage._merchantSaveCard}
    set {_uniqueStorage()._merchantSaveCard = newValue}
  }

  public var blacklistedBins: [String] {
    get {return _storage._blacklistedBins}
    set {_uniqueStorage()._blacklistedBins = newValue}
  }

  public var whitelistedBins: [String] {
    get {return _storage._whitelistedBins}
    set {_uniqueStorage()._whitelistedBins = newValue}
  }

  public var creditCardBank: String {
    get {return _storage._creditCardBank}
    set {_uniqueStorage()._creditCardBank = newValue}
  }

  public var bankRoutingList: [String] {
    get {return _storage._bankRoutingList}
    set {_uniqueStorage()._bankRoutingList = newValue}
  }

  public var bankRoutingAvailable: Bool {
    get {return _storage._bankRoutingAvailable}
    set {_uniqueStorage()._bankRoutingAvailable = newValue}
  }

  public var cardOneClickTokenAvailable: Bool {
    get {return _storage._cardOneClickTokenAvailable}
    set {_uniqueStorage()._cardOneClickTokenAvailable = newValue}
  }

  public var cardTwoClickTokenAvailable: Bool {
    get {return _storage._cardTwoClickTokenAvailable}
    set {_uniqueStorage()._cardTwoClickTokenAvailable = newValue}
  }

  public var installmentRequired: Bool {
    get {return _storage._installmentRequired}
    set {_uniqueStorage()._installmentRequired = newValue}
  }

  public var installmentSource: String {
    get {return _storage._installmentSource}
    set {_uniqueStorage()._installmentSource = newValue}
  }

  public var installmentTerms: String {
    get {return _storage._installmentTerms}
    set {_uniqueStorage()._installmentTerms = newValue}
  }

  public var installmentBank: [String] {
    get {return _storage._installmentBank}
    set {_uniqueStorage()._installmentBank = newValue}
  }

  public var offlineBins: [String] {
    get {return _storage._offlineBins}
    set {_uniqueStorage()._offlineBins = newValue}
  }

  public var offlineBinsSource: String {
    get {return _storage._offlineBinsSource}
    set {_uniqueStorage()._offlineBinsSource = newValue}
  }

  public var minimumAmountBanks: String {
    get {return _storage._minimumAmountBanks}
    set {_uniqueStorage()._minimumAmountBanks = newValue}
  }

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  required public init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Midtrans_Clickstream_Meta_CreditCard: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "midtrans.clickstream.meta"

extension Midtrans_Clickstream_Meta_CreditCard: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".CreditCard"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "saved_tokens_number"),
    2: .same(proto: "secure"),
    3: .standard(proto: "save_card"),
    4: .standard(proto: "merchant_save_card"),
    5: .standard(proto: "blacklisted_bins"),
    6: .standard(proto: "whitelisted_bins"),
    7: .standard(proto: "credit_card_bank"),
    8: .standard(proto: "bank_routing_list"),
    9: .standard(proto: "bank_routing_available"),
    10: .standard(proto: "card_one_click_token_available"),
    11: .standard(proto: "card_two_click_token_available"),
    12: .standard(proto: "installment_required"),
    13: .standard(proto: "installment_source"),
    14: .standard(proto: "installment_terms"),
    15: .standard(proto: "installment_bank"),
    16: .standard(proto: "offline_bins"),
    17: .standard(proto: "offline_bins_source"),
    18: .standard(proto: "minimum_amount_banks"),
  ]

  public class _StorageClass {
    var _savedTokensNumber: UInt32 = 0
    var _secure: Bool = false
    var _saveCard: Bool = false
    var _merchantSaveCard: Bool = false
    var _blacklistedBins: [String] = []
    var _whitelistedBins: [String] = []
    var _creditCardBank: String = String()
    var _bankRoutingList: [String] = []
    var _bankRoutingAvailable: Bool = false
    var _cardOneClickTokenAvailable: Bool = false
    var _cardTwoClickTokenAvailable: Bool = false
    var _installmentRequired: Bool = false
    var _installmentSource: String = String()
    var _installmentTerms: String = String()
    var _installmentBank: [String] = []
    var _offlineBins: [String] = []
    var _offlineBinsSource: String = String()
    var _minimumAmountBanks: String = String()

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _savedTokensNumber = source._savedTokensNumber
      _secure = source._secure
      _saveCard = source._saveCard
      _merchantSaveCard = source._merchantSaveCard
      _blacklistedBins = source._blacklistedBins
      _whitelistedBins = source._whitelistedBins
      _creditCardBank = source._creditCardBank
      _bankRoutingList = source._bankRoutingList
      _bankRoutingAvailable = source._bankRoutingAvailable
      _cardOneClickTokenAvailable = source._cardOneClickTokenAvailable
      _cardTwoClickTokenAvailable = source._cardTwoClickTokenAvailable
      _installmentRequired = source._installmentRequired
      _installmentSource = source._installmentSource
      _installmentTerms = source._installmentTerms
      _installmentBank = source._installmentBank
      _offlineBins = source._offlineBins
      _offlineBinsSource = source._offlineBinsSource
      _minimumAmountBanks = source._minimumAmountBanks
    }
  }

  fileprivate func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  public func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        // The use of inline closures is to circumvent an issue where the compiler
        // allocates stack space for every case branch when no optimizations are
        // enabled. https://github.com/apple/swift-protobuf/issues/1034
        switch fieldNumber {
        case 1: try { try decoder.decodeSingularUInt32Field(value: &_storage._savedTokensNumber) }()
        case 2: try { try decoder.decodeSingularBoolField(value: &_storage._secure) }()
        case 3: try { try decoder.decodeSingularBoolField(value: &_storage._saveCard) }()
        case 4: try { try decoder.decodeSingularBoolField(value: &_storage._merchantSaveCard) }()
        case 5: try { try decoder.decodeRepeatedStringField(value: &_storage._blacklistedBins) }()
        case 6: try { try decoder.decodeRepeatedStringField(value: &_storage._whitelistedBins) }()
        case 7: try { try decoder.decodeSingularStringField(value: &_storage._creditCardBank) }()
        case 8: try { try decoder.decodeRepeatedStringField(value: &_storage._bankRoutingList) }()
        case 9: try { try decoder.decodeSingularBoolField(value: &_storage._bankRoutingAvailable) }()
        case 10: try { try decoder.decodeSingularBoolField(value: &_storage._cardOneClickTokenAvailable) }()
        case 11: try { try decoder.decodeSingularBoolField(value: &_storage._cardTwoClickTokenAvailable) }()
        case 12: try { try decoder.decodeSingularBoolField(value: &_storage._installmentRequired) }()
        case 13: try { try decoder.decodeSingularStringField(value: &_storage._installmentSource) }()
        case 14: try { try decoder.decodeSingularStringField(value: &_storage._installmentTerms) }()
        case 15: try { try decoder.decodeRepeatedStringField(value: &_storage._installmentBank) }()
        case 16: try { try decoder.decodeRepeatedStringField(value: &_storage._offlineBins) }()
        case 17: try { try decoder.decodeSingularStringField(value: &_storage._offlineBinsSource) }()
        case 18: try { try decoder.decodeSingularStringField(value: &_storage._minimumAmountBanks) }()
        default: break
        }
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if _storage._savedTokensNumber != 0 {
        try visitor.visitSingularUInt32Field(value: _storage._savedTokensNumber, fieldNumber: 1)
      }
      if _storage._secure != false {
        try visitor.visitSingularBoolField(value: _storage._secure, fieldNumber: 2)
      }
      if _storage._saveCard != false {
        try visitor.visitSingularBoolField(value: _storage._saveCard, fieldNumber: 3)
      }
      if _storage._merchantSaveCard != false {
        try visitor.visitSingularBoolField(value: _storage._merchantSaveCard, fieldNumber: 4)
      }
      if !_storage._blacklistedBins.isEmpty {
        try visitor.visitRepeatedStringField(value: _storage._blacklistedBins, fieldNumber: 5)
      }
      if !_storage._whitelistedBins.isEmpty {
        try visitor.visitRepeatedStringField(value: _storage._whitelistedBins, fieldNumber: 6)
      }
      if !_storage._creditCardBank.isEmpty {
        try visitor.visitSingularStringField(value: _storage._creditCardBank, fieldNumber: 7)
      }
      if !_storage._bankRoutingList.isEmpty {
        try visitor.visitRepeatedStringField(value: _storage._bankRoutingList, fieldNumber: 8)
      }
      if _storage._bankRoutingAvailable != false {
        try visitor.visitSingularBoolField(value: _storage._bankRoutingAvailable, fieldNumber: 9)
      }
      if _storage._cardOneClickTokenAvailable != false {
        try visitor.visitSingularBoolField(value: _storage._cardOneClickTokenAvailable, fieldNumber: 10)
      }
      if _storage._cardTwoClickTokenAvailable != false {
        try visitor.visitSingularBoolField(value: _storage._cardTwoClickTokenAvailable, fieldNumber: 11)
      }
      if _storage._installmentRequired != false {
        try visitor.visitSingularBoolField(value: _storage._installmentRequired, fieldNumber: 12)
      }
      if !_storage._installmentSource.isEmpty {
        try visitor.visitSingularStringField(value: _storage._installmentSource, fieldNumber: 13)
      }
      if !_storage._installmentTerms.isEmpty {
        try visitor.visitSingularStringField(value: _storage._installmentTerms, fieldNumber: 14)
      }
      if !_storage._installmentBank.isEmpty {
        try visitor.visitRepeatedStringField(value: _storage._installmentBank, fieldNumber: 15)
      }
      if !_storage._offlineBins.isEmpty {
        try visitor.visitRepeatedStringField(value: _storage._offlineBins, fieldNumber: 16)
      }
      if !_storage._offlineBinsSource.isEmpty {
        try visitor.visitSingularStringField(value: _storage._offlineBinsSource, fieldNumber: 17)
      }
      if !_storage._minimumAmountBanks.isEmpty {
        try visitor.visitSingularStringField(value: _storage._minimumAmountBanks, fieldNumber: 18)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public extension Midtrans_Clickstream_Meta_CreditCard {
         
    @objc public convenience init(properties: [String:Any],
         eventName: String) {

         self.init()
         
    }
}
