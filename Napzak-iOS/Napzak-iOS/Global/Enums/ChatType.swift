//
//  ChatType.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/28/25.
//

enum ChatMessageType: String, Codable {
    case text = "TEXT"
    case image = "IMAGE"
    case product = "PRODUCT"
    case system = "SYSTEM"
    case date = "DATE"
}

enum ChatMetaDataType: Codable {
    case image(ImageMeta)
    case product(ProductMeta)
    case system(SystemMeta)
    case date(DateMeta)
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeString = try container.decode(String.self, forKey: .type)
        
        switch typeString {
        case ChatMessageType.image.rawValue:
            let value = try ImageMeta(from: decoder)
            self = .image(value)
        case ChatMessageType.product.rawValue:
            let value = try ProductMeta(from: decoder)
            self = .product(value)
        case SystemMetaType.exit.rawValue:
            let value = try SystemMeta(from: decoder)
            self = .system(value)
        case SystemMetaType.reported.rawValue:
            let value = try SystemMeta(from: decoder)
            self = .system(value)
        case SystemMetaType.withdrawn.rawValue:
            let value = try SystemMeta(from: decoder)
            self = .system(value)
        case ChatMessageType.date.rawValue:
            let value = try DateMeta(from: decoder)
            self = .date(value)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type,
                                                   in: container,
                                                   debugDescription: "Unknown metadata type: \(typeString)")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .image(let value):
            try value.encode(to: encoder)
        case .product(let value):
            try value.encode(to: encoder)
        case .system(let value):
            try value.encode(to: encoder)
        case .date(let value):
            try value.encode(to: encoder)
        }
    }
}

enum SystemMetaType: String, Codable {
    case exit = "EXIT"
    case reported = "REPORTED"
    case withdrawn = "WITHDRAWN"
}
