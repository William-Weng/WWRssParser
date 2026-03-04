//
//  Model.swift
//  WWRssParser
//
//  Created by William.Weng on 2026/3/4.
//

import Foundation

// MARK: - RSS文件內容
extension WWRssParser.RssItem: Hashable {
    
    /// 判斷是否相等
    /// - Parameters:
    ///   - lhs: RssItem
    ///   - rhs: RssItem
    /// - Returns: Bool
    public static func == (lhs: WWRssParser.RssItem, rhs: WWRssParser.RssItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    /// Hashable 實作
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// 初始化
    /// - Parameter parserItem: ParsedRssItem
    init(from parserItem: WWRssParser.ParsedRssItem) {
        title = parserItem.title
        link = parserItem.link
        summary = parserItem.summary
        description = parserItem.description
        pubDate = parserItem.pubDate
        guid = parserItem.guid
        encoded = parserItem.encoded
    }
}
