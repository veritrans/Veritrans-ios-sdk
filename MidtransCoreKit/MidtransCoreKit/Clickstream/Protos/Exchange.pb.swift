// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: midtrans/clickstream/products/common/Exchange.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

///platform="ios,android"

import Foundation

public class Midtrans_Clickstream_Products_Common_Exchange {
  //  Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///MappedTo: "RequestName"
  public var requestName: String {
    get {return _storage._requestName}
    set {_uniqueStorage()._requestName = newValue}
  }

  public var requestParams: Dictionary<String,String> {
    get {return _storage._requestParams}
    set {_uniqueStorage()._requestParams = newValue}
  }

  public var responseParams: Dictionary<String,String> {
    get {return _storage._responseParams}
    set {_uniqueStorage()._responseParams = newValue}
  }

  public var statusCode: String {
    get {return _storage._statusCode}
    set {_uniqueStorage()._statusCode = newValue}
  }

  public var statusMessage: String {
    get {return _storage._statusMessage}
    set {_uniqueStorage()._statusMessage = newValue}
  }

  public var errorMessage: String {
    get {return _storage._errorMessage}
    set {_uniqueStorage()._errorMessage = newValue}
  }

  public var errorHTTPStatus: String {
    get {return _storage._errorHTTPStatus}
    set {_uniqueStorage()._errorHTTPStatus = newValue}
  }

  public var errorStatus: String {
    get {return _storage._errorStatus}
    set {_uniqueStorage()._errorStatus = newValue}
  }

  public var errorStatusText: String {
    get {return _storage._errorStatusText}
    set {_uniqueStorage()._errorStatusText = newValue}
  }

  public var chargeParams: Midtrans_Clickstream_Products_Common_ChargeParams {
    get {return _storage._chargeParams ?? Midtrans_Clickstream_Products_Common_ChargeParams()}
    set {_uniqueStorage()._chargeParams = newValue}
  }

  public var chargeResponse: Midtrans_Clickstream_Products_Common_ChargeResponse {
    get {return _storage._chargeResponse ?? Midtrans_Clickstream_Products_Common_ChargeResponse()}
    set {_uniqueStorage()._chargeResponse = newValue}
  }

  public var gopayTokenizationResponse: Midtrans_Clickstream_Products_Common_GopayTokenizationResponse {
    get {return _storage._gopayTokenizationResponse ?? Midtrans_Clickstream_Products_Common_GopayTokenizationResponse()}
    set {_uniqueStorage()._gopayTokenizationResponse = newValue}
  }

  public var result3Ds: Midtrans_Clickstream_Products_Common_Result3DS {
    get {return _storage._result3Ds ?? Midtrans_Clickstream_Products_Common_Result3DS()}
    set {_uniqueStorage()._result3Ds = newValue}
  }

  public var exbinResponse: Midtrans_Clickstream_Products_Common_ExbinResponse {
    get {return _storage._exbinResponse ?? Midtrans_Clickstream_Products_Common_ExbinResponse()}
    set {_uniqueStorage()._exbinResponse = newValue}
  }

  public var responseTime: Int64 {
    get {return _storage._responseTime}
    set {_uniqueStorage()._responseTime = newValue}
  }

  public var unknownFields =  UnknownStorage()

  required public init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Midtrans_Clickstream_Products_Common_Exchange: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "midtrans.clickstream.products.common"

extension Midtrans_Clickstream_Products_Common_Exchange:  Message,  _MessageImplementationBase,  _ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".Exchange"
  public static let _protobuf_nameMap:  _NameMap = [
    1: .standard(proto: "request_name"),
    2: .standard(proto: "request_params"),
    3: .standard(proto: "response_params"),
    4: .standard(proto: "status_code"),
    5: .standard(proto: "status_message"),
    6: .standard(proto: "error_message"),
    7: .standard(proto: "error_http_status"),
    8: .standard(proto: "error_status"),
    9: .standard(proto: "error_status_text"),
    10: .standard(proto: "charge_params"),
    11: .standard(proto: "charge_response"),
    12: .standard(proto: "gopay_tokenization_response"),
    13: .standard(proto: "result_3ds"),
    14: .standard(proto: "exbin_response"),
    15: .standard(proto: "response_time"),
  ]

  public class _StorageClass {
    var _requestName: String = String()
    var _requestParams: Dictionary<String,String> = [:]
    var _responseParams: Dictionary<String,String> = [:]
    var _statusCode: String = String()
    var _statusMessage: String = String()
    var _errorMessage: String = String()
    var _errorHTTPStatus: String = String()
    var _errorStatus: String = String()
    var _errorStatusText: String = String()
    var _chargeParams: Midtrans_Clickstream_Products_Common_ChargeParams? = nil
    var _chargeResponse: Midtrans_Clickstream_Products_Common_ChargeResponse? = nil
    var _gopayTokenizationResponse: Midtrans_Clickstream_Products_Common_GopayTokenizationResponse? = nil
    var _result3Ds: Midtrans_Clickstream_Products_Common_Result3DS? = nil
    var _exbinResponse: Midtrans_Clickstream_Products_Common_ExbinResponse? = nil
    var _responseTime: Int64 = 0

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _requestName = source._requestName
      _requestParams = source._requestParams
      _responseParams = source._responseParams
      _statusCode = source._statusCode
      _statusMessage = source._statusMessage
      _errorMessage = source._errorMessage
      _errorHTTPStatus = source._errorHTTPStatus
      _errorStatus = source._errorStatus
      _errorStatusText = source._errorStatusText
      _chargeParams = source._chargeParams
      _chargeResponse = source._chargeResponse
      _gopayTokenizationResponse = source._gopayTokenizationResponse
      _result3Ds = source._result3Ds
      _exbinResponse = source._exbinResponse
      _responseTime = source._responseTime
    }
  }

  fileprivate func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  public func decodeMessage<D:  Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        // The use of inline closures is to circumvent an issue where the compiler
        // allocates stack space for every case branch when no optimizations are
        // enabled. https://github.com/apple/swift-protobuf/issues/1034
        switch fieldNumber {
        case 1: try { try decoder.decodeSingularStringField(value: &_storage._requestName) }()
        case 2: try { try decoder.decodeMapField(fieldType:  _ProtobufMap< ProtobufString, ProtobufString>.self, value: &_storage._requestParams) }()
        case 3: try { try decoder.decodeMapField(fieldType:  _ProtobufMap< ProtobufString, ProtobufString>.self, value: &_storage._responseParams) }()
        case 4: try { try decoder.decodeSingularStringField(value: &_storage._statusCode) }()
        case 5: try { try decoder.decodeSingularStringField(value: &_storage._statusMessage) }()
        case 6: try { try decoder.decodeSingularStringField(value: &_storage._errorMessage) }()
        case 7: try { try decoder.decodeSingularStringField(value: &_storage._errorHTTPStatus) }()
        case 8: try { try decoder.decodeSingularStringField(value: &_storage._errorStatus) }()
        case 9: try { try decoder.decodeSingularStringField(value: &_storage._errorStatusText) }()
        case 10: try { try decoder.decodeSingularMessageField(value: &_storage._chargeParams) }()
        case 11: try { try decoder.decodeSingularMessageField(value: &_storage._chargeResponse) }()
        case 12: try { try decoder.decodeSingularMessageField(value: &_storage._gopayTokenizationResponse) }()
        case 13: try { try decoder.decodeSingularMessageField(value: &_storage._result3Ds) }()
        case 14: try { try decoder.decodeSingularMessageField(value: &_storage._exbinResponse) }()
        case 15: try { try decoder.decodeSingularInt64Field(value: &_storage._responseTime) }()
        default: break
        }
      }
    }
  }

  public func traverse<V:  Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every if/case branch local when no optimizations
      // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
      // https://github.com/apple/swift-protobuf/issues/1182
      if !_storage._requestName.isEmpty {
        try visitor.visitSingularStringField(value: _storage._requestName, fieldNumber: 1)
      }
      if !_storage._requestParams.isEmpty {
        try visitor.visitMapField(fieldType:  _ProtobufMap< ProtobufString, ProtobufString>.self, value: _storage._requestParams, fieldNumber: 2)
      }
      if !_storage._responseParams.isEmpty {
        try visitor.visitMapField(fieldType:  _ProtobufMap< ProtobufString, ProtobufString>.self, value: _storage._responseParams, fieldNumber: 3)
      }
      if !_storage._statusCode.isEmpty {
        try visitor.visitSingularStringField(value: _storage._statusCode, fieldNumber: 4)
      }
      if !_storage._statusMessage.isEmpty {
        try visitor.visitSingularStringField(value: _storage._statusMessage, fieldNumber: 5)
      }
      if !_storage._errorMessage.isEmpty {
        try visitor.visitSingularStringField(value: _storage._errorMessage, fieldNumber: 6)
      }
      if !_storage._errorHTTPStatus.isEmpty {
        try visitor.visitSingularStringField(value: _storage._errorHTTPStatus, fieldNumber: 7)
      }
      if !_storage._errorStatus.isEmpty {
        try visitor.visitSingularStringField(value: _storage._errorStatus, fieldNumber: 8)
      }
      if !_storage._errorStatusText.isEmpty {
        try visitor.visitSingularStringField(value: _storage._errorStatusText, fieldNumber: 9)
      }
      try { if let v = _storage._chargeParams {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 10)
      } }()
      try { if let v = _storage._chargeResponse {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 11)
      } }()
      try { if let v = _storage._gopayTokenizationResponse {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 12)
      } }()
      try { if let v = _storage._result3Ds {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 13)
      } }()
      try { if let v = _storage._exbinResponse {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 14)
      } }()
      if _storage._responseTime != 0 {
        try visitor.visitSingularInt64Field(value: _storage._responseTime, fieldNumber: 15)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public extension Midtrans_Clickstream_Products_Common_Exchange {
         
    @objc public convenience init(properties: [String:Any],
         eventName: String) {

         self.init()
         
        if let requestName: String = properties["RequestName"] as? String {
            self.requestName = requestName
        }
 self.chargeParams = Midtrans_Clickstream_Products_Common_ChargeParams(properties: properties, eventName: eventName) 
 self.chargeResponse = Midtrans_Clickstream_Products_Common_ChargeResponse(properties: properties, eventName: eventName) 
 self.gopayTokenizationResponse = Midtrans_Clickstream_Products_Common_GopayTokenizationResponse(properties: properties, eventName: eventName) 
 self.result3Ds = Midtrans_Clickstream_Products_Common_Result3DS(properties: properties, eventName: eventName) 
 self.exbinResponse = Midtrans_Clickstream_Products_Common_ExbinResponse(properties: properties, eventName: eventName) 
    }
}
