//
//  Constant.swift
//  WWRssParser
//
//  Created by William.Weng on 2026/3/4.
//

import Foundation

// MARK: - 常數
public extension WWRssParser {
    
    /// 自定義錯誤
    enum CustomError: Error {
        case responseInvalid                                // 不是回傳HTTP Response
        case urlStringInvalid                               // 不是可用的URL網址
        case parsingFailed(_ response: HTTPURLResponse)     // RSS解析錯誤 (400)
    }
    
    /// XML類型
    enum XMLType {
        
        case RSS    // RSS 2.0
        case Atom   // Atom 1.0
        
        /// 由元素名稱找出XML類型
        /// - Parameter elementName: String
        /// - Returns: XMLType?
        static func findElementType(_ elementName: String) -> XMLType? {
            
            switch elementName.lowercased() {
            case "rss": return .RSS
            case "feed": return .Atom
            default: return nil
            }
        }
    }
}

// MARK: - 常數
extension WWRssParser {
    
    /// RSS元件類型 => <item></item>
    enum ElementNameType: String, CaseIterable {
        
        case item
        case entry
        case title
        case link
        case description
        case pubDate
        case updated
        case guid
        case id
        case summary
        case content
        case encoded = "content:encoded"
    }
}
