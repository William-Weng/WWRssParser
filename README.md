# WWRssParser
[![Swift-5.7](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-15.0](https://img.shields.io/badge/iOS-15.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![TAG](https://img.shields.io/github/v/tag/William-Weng/WWRssParser) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

### [Introduction - 簡介](https://swiftpackageindex.com/William-Weng)
- [A lightweight, pure Swift RSS parser designed specifically for iOS development.](https://validator.w3.org/feed/docs/rss2.html)
- [是一個輕量級、純 Swift 寫的 RSS 解析器，專為 iOS 開發設計。](https://blog.gslin.org/archives/2022/07/02/10772/自己刻-rss-2-0-的簡單方式/)

https://github.com/user-attachments/assets/9e5e8182-51e6-4a32-b401-bf1e1a5fc376

### [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)
```bash
dependencies: [
    .package(url: "https://github.com/William-Weng/WWRssParser.git", .upToNextMajor(from: "1.0.0"))
]
```

### 可用函式 (Function)
|函式|功能|
|-|-|
|fetch(url:)|抓取RSS資料|
|parse(data:)|解析RSS資料|
|parse(url:)|解析線上RSS資料|

### Example
```swift
import UIKit
import WWRssParser

final class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
        
    private var items: [WWRssParser.RssItem] = []
    private lazy var dataSource = dataSourceMaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    @IBAction func reloadDataAction(_ sender: UIBarButtonItem) {
        reloadData(url: "https://feeds.bbci.co.uk/news/rss.xml")
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        title = item.title
    }
}

private extension ViewController {
    
    func reloadData(url: String) {
        
        Task {
            do {
                let items = try await WWRssParser.shared.parse(url: url).get()
                self.items = items
                
                await MainActor.run { self.applySnapshot() }
                
            } catch {
                print(error)
            }
        }
    }
    
    func dataSourceMaker() -> UITableViewDiffableDataSource<Int, WWRssParser.RssItem> {
        
        let source = UITableViewDiffableDataSource<Int, WWRssParser.RssItem>(tableView: tableView) { tableView, indexPath, rss in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RSSItemCell", for: indexPath)
            
            cell.textLabel?.text = rss.title
            cell.textLabel?.numberOfLines = 0
            
            return cell
        }
        
        return source
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        
        let section: Int = 0
        var snapshot = NSDiffableDataSourceSnapshot<Int, WWRssParser.RssItem>()
        
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
```
