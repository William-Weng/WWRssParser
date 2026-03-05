//
//  WWRssParser.swift
//  WWRssParser
//
//  Created by William.Weng on 2026/3/4.
//

import Foundation

// MARK: - RSS讀取器
open class WWRssParser: NSObject {
    
    @MainActor
    public static let shared = WWRssParser()
        
    private let rssParser = RssParser()
    
    public struct RssItem: Codable, Identifiable {
        
        public let id = UUID()
        
        public let title: String
        public let link: String
        public let guid: String
        public let summary: String
        public let description: String
        public let pubDate: String
        public let encoded: String
        
        enum CodingKeys: String, CodingKey {
            case title
            case guid
            case link
            case summary
            case description
            case pubDate
            case encoded
        }
    }
    
    // MARK: - RSS文件暫存
    struct ParsedRssItem {
        var title: String = .init()
        var link: String = .init()
        var guid: String = .init()
        var summary: String = .init()
        var description: String = .init()
        var pubDate: String = .init()
        var encoded: String = .init()
    }
    
    // MARK: - RSS解析器
    class RssParser: NSObject {
        
        var xmlType: WWRssParser.XMLType? = nil
        
        var currentElement: String = .init()
        var foundCharacters: String = .init()
        var items: [ParsedRssItem] = .init()
        var currentItem: ParsedRssItem = .init()
    }
}

// MARK: - 公開函數
public extension WWRssParser {
    
    /// 抓取RSS資料
    /// - Parameter urlString: RSS網址
    /// - Returns: Result<Data, Error>
    func fetch(url urlString: String) async -> Result<Data, Error> {
        
        do {
            guard let url = URL(string: urlString) else { return .failure(CustomError.urlStringInvalid) }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else { return .failure(CustomError.responseInvalid) }
            
            guard httpResponse.isSuccessful,
                  httpResponse.isRSSContentType
            else {
                return .failure(CustomError.parsingFailed(httpResponse))
            }
            
            return .success(data)
            
        } catch {
            return .failure(error)
        }
    }
    
    /// 解析RSS資料
    /// - Parameter data: Data
    /// - Returns: XMLTypeValue
    func parse(data: Data) -> Result<XMLTypeValue, CustomError> {
                
        let items = rssParser.parse(data: data)
        
        switch rssParser.xmlType {
        case .Atom: return .success(.Atom(items))
        case .RSS: return .success(.RSS(items))
        default: return .failure(CustomError.dataInvalid)
        }
    }
    
    /// 解析線上RSS資料
    /// - Parameter url: RSS網址
    /// - Returns: Result<XMLTypeValue, Error>
    func parse(url: String) async -> Result<XMLTypeValue, Error> {
        
        do {
            let data = try await fetch(url: url).get()
            let xmlTypeValue = try parse(data: data).get()
            return .success(xmlTypeValue)
        } catch {
            return .failure(error)
        }
    }
}
