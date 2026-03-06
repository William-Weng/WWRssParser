//
//  Extension.swift
//  WWRssParser
//
//  Created by William.Weng on 2026/3/4.
//

import UIKit

// MARK: - String
public extension String {
    
    /// 轉成對HTML支援
    /// - Parameters:
    ///   - encoding: 字元編碼
    ///   - allowLossyConversion: Bool
    ///   - font: 字型
    ///   - foregroundColor: 文字顏色
    /// - Returns: NSAttributedString?
    func _html(using encoding: String.Encoding = .utf8, allowLossyConversion: Bool = false, font: UIFont? = nil, foregroundColor: UIColor? = nil) -> NSMutableAttributedString? {
        
        guard let data = data(using: encoding, allowLossyConversion: allowLossyConversion),
              let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        else {
            return nil
        }
        
        let textRange = NSRange(location: 0, length: attributedString.length)
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        
        if let font = font {
            mutableAttributedString.addAttribute(.font, value: font, range: textRange)
            mutableAttributedString.addAttribute(.underlineColor, value: UIColor.systemBlue, range: textRange)
        }
        
        if let foregroundColor = foregroundColor {
            mutableAttributedString.addAttribute(.foregroundColor, value: foregroundColor, range: textRange)
        }
        
        return mutableAttributedString
    }
}

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
