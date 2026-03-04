//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2026/3/4.
//

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

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        title = item.title
    }
}

// MARK: - 小工具
private extension ViewController {
    
    /// 讀取線上的RSS文件
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
    
    /// 建立DataSource
    /// - Returns: UITableViewDiffableDataSource<Int, WWRssParser.RssItem>
    func dataSourceMaker() -> UITableViewDiffableDataSource<Int, WWRssParser.RssItem> {
        
        let source = UITableViewDiffableDataSource<Int, WWRssParser.RssItem>(tableView: tableView) { tableView, indexPath, rss in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RSSItemCell", for: indexPath)
            
            cell.textLabel?.text = rss.title
            cell.textLabel?.numberOfLines = 0
            
            return cell
        }
        
        return source
    }
    
    /// 畫面更新 => 資料快照
    /// - Parameter animatingDifferences: Bool
    func applySnapshot(animatingDifferences: Bool = true) {
        
        let section: Int = 0
        var snapshot = NSDiffableDataSourceSnapshot<Int, WWRssParser.RssItem>()
        
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

