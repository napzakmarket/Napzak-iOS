//
//  Encodable+.swift
//  Napzakm-iOS
//
//  Created by 조혜린 on 3/14/25.
//

import Foundation

extension Encodable {
    
    var jsonString: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self),
              let json = String(data: data, encoding: .utf8) else { return "{}" }
        return json
    }
    
}
