// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let regulaResponse = try? newJSONDecoder().decode(RegulaResponse.self, from: jsonData)

import Foundation

// MARK: - RegulaResponse
struct RegulaResponse: Codable {
    var chipPage: Int?
    var containerList: ContainerList?
    var coreLIBResultCode, processingFinished: Int?
    var transactionInfo: TransactionInfo?
    var elapsedTime, morePagesAvailable: Int?
    var passBackObject: JSONNull?
    var serviceMemorySizeMaxExceeded: Bool?

    enum CodingKeys: String, CodingKey {
        case chipPage = "ChipPage"
        case containerList = "ContainerList"
        case coreLIBResultCode = "CoreLibResultCode"
        case processingFinished = "ProcessingFinished"
        case transactionInfo = "TransactionInfo"
        case elapsedTime, morePagesAvailable, passBackObject, serviceMemorySizeMaxExceeded
    }
}

// MARK: - ContainerList
struct ContainerList: Codable {
    var count: Int?
    var list: [ContainerListList]?

    enum CodingKeys: String, CodingKey {
        case count = "Count"
        case list = "List"
    }
}

// MARK: - ContainerListList
public struct ContainerListList: Codable {
    var docVisualExtendedInfo: DocVisualExtendedInfo?
    var bufLength, light, listIdx, pageIdx: Int?
    var resultType: Int?
    var resultMRZDetector: ResultMRZDetector?
    var mrzPosition: Position?
    var mrzTestQuality: MRZTestQuality?
    var faceDetection: FaceDetection?
    var documentPosition: Position?
    var oneCandidate: OneCandidate?
    var docGraphicsInfo: DocGraphicsInfo?
    var imageQualityCheckList: ImageQualityCheckList?
    var listVerifiedFields: ListVerifiedFields?
    var text: RegulaText?
    var images: Images?
    var status: Status?

    enum CodingKeys: String, CodingKey {
        case docVisualExtendedInfo = "DocVisualExtendedInfo"
        case bufLength = "buf_length"
        case light
        case listIdx = "list_idx"
        case pageIdx = "page_idx"
        case resultType = "result_type"
        case resultMRZDetector = "ResultMRZDetector"
        case mrzPosition = "MrzPosition"
        case mrzTestQuality = "MRZTestQuality"
        case faceDetection = "FaceDetection"
        case documentPosition = "DocumentPosition"
        case oneCandidate = "OneCandidate"
        case docGraphicsInfo = "DocGraphicsInfo"
        case imageQualityCheckList = "ImageQualityCheckList"
        case listVerifiedFields = "ListVerifiedFields"
        case text = "Text"
        case images = "Images"
        case status = "Status"
    }
}

// MARK: - DocGraphicsInfo
struct DocGraphicsInfo: Codable {
    var nFields: Int?
    var pArrayFields: [DocGraphicsInfoPArrayField]?
}

// MARK: - DocGraphicsInfoPArrayField
struct DocGraphicsInfoPArrayField: Codable {
    var fieldName: String?
    var fieldRect: FieldRect?
    var fieldType: Int?
    var image: Image?

    enum CodingKeys: String, CodingKey {
        case fieldName = "FieldName"
        case fieldRect = "FieldRect"
        case fieldType = "FieldType"
        case image
    }
}

// MARK: - FieldRect
struct FieldRect: Codable {
    var bottom, fieldRectLeft, fieldRectRight, top: Int?

    enum CodingKeys: String, CodingKey {
        case bottom
        case fieldRectLeft = "left"
        case fieldRectRight = "right"
        case top
    }
}

// MARK: - Image
struct Image: Codable {
    var format, image: String?
}

// MARK: - DocVisualExtendedInfo
struct DocVisualExtendedInfo: Codable {
    var nFields: Int?
    var pArrayFields: [DocVisualExtendedInfoPArrayField]?
}

// MARK: - DocVisualExtendedInfoPArrayField
struct DocVisualExtendedInfoPArrayField: Codable {
    var bufLength: Int?
    var bufText, fieldMask, fieldName: String?
    var fieldRect: FieldRect?
    var fieldType, inComparison, reserved2, reserved3: Int?
    var stringsCount: Int?
    var stringsResult: [StringsResult]?
    var validity, wFieldType, wLCID: Int?

    enum CodingKeys: String, CodingKey {
        case bufLength = "Buf_Length"
        case bufText = "Buf_Text"
        case fieldMask = "FieldMask"
        case fieldName = "FieldName"
        case fieldRect = "FieldRect"
        case fieldType = "FieldType"
        case inComparison = "InComparison"
        case reserved2 = "Reserved2"
        case reserved3 = "Reserved3"
        case stringsCount = "StringsCount"
        case stringsResult = "StringsResult"
        case validity = "Validity"
        case wFieldType, wLCID
    }
}

// MARK: - StringsResult
struct StringsResult: Codable {
    var reserved: Int?
    var stringResult: [StringResult]?
    var symbolsCount: Int?

    enum CodingKeys: String, CodingKey {
        case reserved = "Reserved"
        case stringResult = "StringResult"
        case symbolsCount = "SymbolsCount"
    }
}

// MARK: - StringResult
struct StringResult: Codable {
    var baseLineBottom, baseLineTop, candidatesCount: Int?
    var listOfCandidates: [ListOfCandidate]?
    var reserved: Int?
    var symbolRect: FieldRect?

    enum CodingKeys: String, CodingKey {
        case baseLineBottom = "BaseLineBottom"
        case baseLineTop = "BaseLineTop"
        case candidatesCount = "CandidatesCount"
        case listOfCandidates = "ListOfCandidates"
        case reserved = "Reserved"
        case symbolRect = "SymbolRect"
    }
}

// MARK: - ListOfCandidate
struct ListOfCandidate: Codable {
    var listOfCandidateClass, subClass, symbolCode, symbolProbability: Int?

    enum CodingKeys: String, CodingKey {
        case listOfCandidateClass = "Class"
        case subClass = "SubClass"
        case symbolCode = "SymbolCode"
        case symbolProbability = "SymbolProbability"
    }
}

// MARK: - Position
struct Position: Codable {
    var angle: Int?
    var center: Center?
    var dpi, height, inverse: Int?
    var leftBottom, leftTop: Center?
    var objArea, objIntAngleDev, perspectiveTr, resultStatus: Int?
    var rightBottom, rightTop: Center?
    var width, docFormat: Int?

    enum CodingKeys: String, CodingKey {
        case angle = "Angle"
        case center = "Center"
        case dpi = "Dpi"
        case height = "Height"
        case inverse = "Inverse"
        case leftBottom = "LeftBottom"
        case leftTop = "LeftTop"
        case objArea = "ObjArea"
        case objIntAngleDev = "ObjIntAngleDev"
        case perspectiveTr = "PerspectiveTr"
        case resultStatus = "ResultStatus"
        case rightBottom = "RightBottom"
        case rightTop = "RightTop"
        case width = "Width"
        case docFormat
    }
}

// MARK: - Center
struct Center: Codable {
    var x, y: Int?
}

// MARK: - FaceDetection
struct FaceDetection: Codable {
    var count, countFalseDetection: Int?
    var res: [Re]?
    var reserved1, reserved2: Int?

    enum CodingKeys: String, CodingKey {
        case count = "Count"
        case countFalseDetection = "CountFalseDetection"
        case res = "Res"
        case reserved1 = "Reserved1"
        case reserved2 = "Reserved2"
    }
}

// MARK: - Re
struct Re: Codable {
    var coincidenceToPhotoArea, lightType, orientation, probability: Int?
    var rectPhoto: FieldRect?
    var reserved: Int?
    var pRects: FieldRect?

    enum CodingKeys: String, CodingKey {
        case coincidenceToPhotoArea = "CoincidenceToPhotoArea"
        case lightType = "LightType"
        case orientation = "Orientation"
        case probability = "Probability"
        case rectPhoto = "Rect_Photo"
        case reserved = "Reserved"
        case pRects
    }
}

// MARK: - ImageQualityCheckList
struct ImageQualityCheckList: Codable {
    var count: Int?
    var list: [ImageQualityCheckListList]?
    var result: Int?

    enum CodingKeys: String, CodingKey {
        case count = "Count"
        case list = "List"
        case result
    }
}

// MARK: - ImageQualityCheckListList
struct ImageQualityCheckListList: Codable {
    var featureType: Int?
    var mean: Double?
    var probability, result: Int?
    var stdDev: Double?
    var type: Int?

    enum CodingKeys: String, CodingKey {
        case featureType, mean, probability, result
        case stdDev = "std_dev"
        case type
    }
}

// MARK: - Images
struct Images: Codable {
    var availableSourceList: [ImagesAvailableSourceList]?
    var fieldList: [ImagesFieldList]?
}

// MARK: - ImagesAvailableSourceList
struct ImagesAvailableSourceList: Codable {
    var containerType: Int?
    var source: Source?
}

enum Source: String, Codable {
    case mrz = "MRZ"
    case visual = "VISUAL"
}

// MARK: - ImagesFieldList
struct ImagesFieldList: Codable {
    var fieldName: String?
    var fieldType: Int?
    var valueList: [PurpleValueList]?
}

// MARK: - PurpleValueList
struct PurpleValueList: Codable {
    var containerType: Int?
    var fieldRect: FieldRect?
    var lightIndex, originalPageIndex, pageIndex: Int?
    var source: Source?
    var value: String?
}

// MARK: - ListVerifiedFields
struct ListVerifiedFields: Codable {
    var count: Int?
    var pDateFormat: String?
    var pFieldMaps: [PFieldMap]?

    enum CodingKeys: String, CodingKey {
        case count = "Count"
        case pDateFormat, pFieldMaps
    }
}

// MARK: - PFieldMap
struct PFieldMap: Codable {
    var fieldType: Int?
    var fieldMRZ, fieldVisual: String?
    var matrix: [Int]?
    var wFieldType, wLCID: Int?

    enum CodingKeys: String, CodingKey {
        case fieldType = "FieldType"
        case fieldMRZ = "Field_MRZ"
        case fieldVisual = "Field_Visual"
        case matrix = "Matrix"
        case wFieldType, wLCID
    }
}

// MARK: - MRZTestQuality
struct MRZTestQuality: Codable {
    var checkSums, contrastPrint, docFormat, mrzFormat: Int?
    var printPosition, stainMrz, symbolsParam, strCount: Int?
    var strings: [JSONAny]?
    var textualFilling: Int?

    enum CodingKeys: String, CodingKey {
        case checkSums = "CHECK_SUMS"
        case contrastPrint = "CONTRAST_PRINT"
        case docFormat = "DOC_FORMAT"
        case mrzFormat = "MRZ_FORMAT"
        case printPosition = "PRINT_POSITION"
        case stainMrz = "STAIN_MRZ"
        case symbolsParam = "SYMBOLS_PARAM"
        case strCount = "StrCount"
        case strings = "Strings"
        case textualFilling = "TEXTUAL_FILLING"
    }
}

// MARK: - OneCandidate
struct OneCandidate: Codable {
    var authenticityNecessaryLights, checkAuthenticity: Int?
    var documentName: String?
    var fdsidList: FDSIDList?
    var id, necessaryLights, oviExp: Int?
    var p: Double?
    var rfidPresence, rotated180, rotationAngle, uvExp: Int?

    enum CodingKeys: String, CodingKey {
        case authenticityNecessaryLights = "AuthenticityNecessaryLights"
        case checkAuthenticity = "CheckAuthenticity"
        case documentName = "DocumentName"
        case fdsidList = "FDSIDList"
        case id = "ID"
        case necessaryLights = "NecessaryLights"
        case oviExp = "OVIExp"
        case p = "P"
        case rfidPresence = "RFID_Presence"
        case rotated180 = "Rotated180"
        case rotationAngle = "RotationAngle"
        case uvExp = "UVExp"
    }
}

// MARK: - FDSIDList
struct FDSIDList: Codable {
    var count: Int?
    var icaoCode: String?
    var list: [Int]?
    var dCountryName: String?
    var dFormat: Int?
    var dMRZ: Bool?
    var dType: Int?
    var dYear: String?

    enum CodingKeys: String, CodingKey {
        case count = "Count"
        case icaoCode = "ICAOCode"
        case list = "List"
        case dCountryName, dFormat, dMRZ, dType, dYear
    }
}

// MARK: - ResultMRZDetector
struct ResultMRZDetector: Codable {
    var mrzFormat: Int?
    var mrzRows: [MRZRow]?
    var mrzRowsNum: Int?
    var boundingQuadrangle: [Int]?

    enum CodingKeys: String, CodingKey {
        case mrzFormat = "MRZFormat"
        case mrzRows = "MRZRows"
        case mrzRowsNum = "MRZRowsNum"
        case boundingQuadrangle
    }
}

// MARK: - MRZRow
struct MRZRow: Codable {
    var length, maxLength: Int?
    var symbols: [Symbol]?
}

// MARK: - Symbol
struct Symbol: Codable {
    var boundingRect: [Int]?
}

// MARK: - Status
struct Status: Codable {
    var detailsOptical: [String: Int]?
    var detailsRFID: DetailsRFID?
    var optical, overallStatus, portrait, rfid: Int?
    var stopList: Int?
}

// MARK: - DetailsRFID
struct DetailsRFID: Codable {
    var aa, bac, ca, pa: Int?
    var pace, ta, overallStatus: Int?

    enum CodingKeys: String, CodingKey {
        case aa = "AA"
        case bac = "BAC"
        case ca = "CA"
        case pa = "PA"
        case pace = "PACE"
        case ta = "TA"
        case overallStatus
    }
}

// MARK: - Text
struct RegulaText: Codable {
    var availableSourceList: [TextAvailableSourceList]?
    var comparisonStatus: Int?
    var dateFormat: String?
    var fieldList: [TextFieldList]?
    var status, validityStatus: Int?
}

// MARK: - TextAvailableSourceList
struct TextAvailableSourceList: Codable {
    var containerType: Int?
    var source: Source?
    var validityStatus: Int?
}

// MARK: - TextFieldList
struct TextFieldList: Codable {
    var comparisonList: [ComparisonList]?
    var comparisonStatus: Int?
    var fieldName: String?
    var fieldType, lcid: Int?
    var lcidName: String?
    var status: Int?
    var validityList: [ValidityList]?
    var validityStatus: Int?
    var value: String?
    var valueList: [FluffyValueList]?
}

// MARK: - ComparisonList
struct ComparisonList: Codable {
    var sourceLeft, sourceRight: Source?
    var status: Int?
}

// MARK: - ValidityList
struct ValidityList: Codable {
    var source: Source?
    var status: Int?
}

// MARK: - FluffyValueList
struct FluffyValueList: Codable {
    var containerType: Int?
    var originalSymbols: [OriginalSymbol]?
    var originalValidity, pageIndex, probability: Int?
    var source: Source?
    var value: String?
    var fieldRect: FieldRect?
    var originalValue: String?
}

// MARK: - OriginalSymbol
struct OriginalSymbol: Codable {
    var code, probability: Int?
    var rect: FieldRect?
}

// MARK: - TransactionInfo
struct TransactionInfo: Codable {
    var computerName, dateTime, systemInfo, transactionID: String?
    var userName, version: String?

    enum CodingKeys: String, CodingKey {
        case computerName = "ComputerName"
        case dateTime = "DateTime"
        case systemInfo = "SystemInfo"
        case transactionID = "TransactionID"
        case userName = "UserName"
        case version = "Version"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
