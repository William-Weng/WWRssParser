//
//  RssParser.swift
//  WWRssParser
//
//  Created by William.Weng on 2026/3/4.
//

import Foundation

// MARK: - RssParser
extension WWRssParser.RssParser {
        
    /// 解析RSS資訊
    /// - Parameter data: Data
    /// - Returns: WWRssParser.RssItem
    func parse(data: Data) -> [WWRssParser.RssItem] {
        
        let parser = XMLParser(data: data)
        
        xmlType = nil
        parser.delegate = self
        parser.parse()
        
        return items.map { WWRssParser.RssItem(from: $0) }
    }
}

// MARK: - XMLParserDelegate
extension WWRssParser.RssParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print(elementName)
        
        if (xmlType == nil) { xmlType = WWRssParser.XMLType.findElementType(elementName) }
        parserDidStartDocument(parser, elementName: elementName)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        parserFoundCharacters(parser, string: string)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        parserDidEndDocument(parser, elementName: elementName)
    }
}

// MARK: - 小工具
private extension WWRssParser.RssParser {
    
    /// 重新建立RssItem (清暫存)
    func renewCurrentItem() {
        currentItem = WWRssParser.ParsedRssItem()
    }
    
    /// 解析HTML的開頭標籤元素 => <title>
    /// - Parameters:
    ///   - parser: XMLParser
    ///   - elementName: 標籤元素名稱
    func parserDidStartDocument(_ parser: XMLParser, elementName: String) {
        
        if let elementNameType = WWRssParser.ElementNameType(rawValue: elementName), elementNameType == .item { renewCurrentItem() }
                
        currentElement = elementName
        foundCharacters = ""
    }
    
    /// 解析HTML的結尾標籤元素 => </title>
    /// - Parameters:
    ///   - parser: XMLParser
    ///   - elementName: 標籤元素名稱
    func parserDidEndDocument(_ parser: XMLParser, elementName: String) {
        
        guard let elementNameType = WWRssParser.ElementNameType(rawValue: elementName) else { return }
        
        switch elementNameType {
        case .item, .entry: items.append(currentItem)
        case .title: currentItem.title = foundCharacters
        case .link: currentItem.link = foundCharacters
        case .description, .content: currentItem.description = foundCharacters
        case .summary: currentItem.description = foundCharacters
        case .pubDate, .updated: currentItem.pubDate = foundCharacters
        case .guid, .id: currentItem.guid = foundCharacters
        case .encoded: currentItem.encoded = foundCharacters
        }
        
        currentElement = ""
        foundCharacters = ""
    }
    
    /// 取得標籤元素中間的字 => <title>我是文字</title>
    /// - Parameters:
    ///   - parser: XMLParser
    ///   - string: String
    func parserFoundCharacters(_ parser: XMLParser, string: String) {
        foundCharacters += string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
