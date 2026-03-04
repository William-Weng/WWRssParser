//
//  Extension.swift
//  WWRssParser
//
//  Created by William.Weng on 2026/3/4.
//

import Foundation

// MARK: - HTTPURLResponse
extension HTTPURLResponse {
    
    /// HTTP狀態碼是否在正常範圍
    var isSuccessful: Bool {
        (200..<300).contains(statusCode)
    }
    
    /// 內容類型是不是RSS / XML
    var isRSSContentType: Bool {
        guard let contentType = value(forHTTPHeaderField: "Content-Type")?.lowercased() else { return false }
        return contentType.contains("xml") || contentType.contains("rss")
    }
}
