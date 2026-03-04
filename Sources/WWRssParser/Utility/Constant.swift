//
//  Constant.swift
//  WWRssParser
//
//  Created by iOS on 2026/3/4.
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
}

// MARK: - 常數
extension WWRssParser {
    
    /// RSS元件類型 => <item></item>
    enum ElementNameType: String, CaseIterable {
        
        case item
        case title
        case link
        case description
        case pubDate
        case guid
        case encoded = "content:encoded"
    }
}
