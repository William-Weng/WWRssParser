//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2026/3/4.
//

import UIKit
import WWRssParser

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
                let xmlItems = try await WWRssParser.shared.parse(url: url).get()
                
                switch xmlItems {
                case .Atom(let items): self.items = items
                case .RSS(let items): self.items = items
                }
                
                await MainActor.run { self.applySnapshot() }
                
            } catch {
                print(error)
            }
        }
    }
    
    func dataSourceMaker() -> UITableViewDiffableDataSource<Int, WWRssParser.RssItem> {
        
        let source = UITableViewDiffableDataSource<Int, WWRssParser.RssItem>(tableView: tableView) { tableView, indexPath, rss in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RSSItemCell", for: indexPath)
            
            cell.textLabel?.attributedText = rss.title._html()
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
