//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/1/1.
//

import UIKit
import WWPrint
import WWCompositionalLayout

// MARK: - ViewController
final class ViewController: UIViewController {
    
    private enum CollectionViewType: Int {
        case item = 101
        case tag = 201
        case content = 301
    }
    
    private let badgeViewKey = "Badge"
    private let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    private let edgeInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
    private let contentCollectionViewItemCount: CGFloat = 3
    
    private var currentLayoutIndex = 0
    private var contentCollectionViewHeight: (header: CGFloat, item: CGFloat) = (30, 120)
    private var isSelectItem = false

    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSectionsAction(in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewAction(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionViewAction(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionViewAction(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionViewAction(collectionView, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let itemCell = cell as? CellReusable else { return }
        itemCell.setBackgroundColor()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let headerView = view as? CellReusable else { return }
        headerView.setBackgroundColor()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScrollAction(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimationAction(scrollView)
    }
}

// MARK: - 小工具
private extension ViewController {
    
    /// 初始化參數 (layout / 設定)
    func initSetting() {
        
        itemCollectionView._delegateAndDataSource(with: self)
        tagCollectionView._delegateAndDataSource(with: self)
        contentCollectionView._delegateAndDataSource(with: self)
        
        itemCollectionView.setCollectionViewLayout(tableViewLayout()!, animated: true)
        tagCollectionView.setCollectionViewLayout(bookshelfLayout()!, animated: true)
        contentCollectionView.setCollectionViewLayout(photoAlbumLayout()!, animated: true)
        
        itemCollectionView._hideScrollIndicator()
        tagCollectionView._hideScrollIndicator()
        contentCollectionView._hideScrollIndicator()
        
        ItemCell.selectedIndexPath = IndexPath(row: 0, section: 0)
        itemCollectionViewSetting(with: ItemCell.selectedIndexPath)
        tagCollectionViewSetting(with: ItemCell.selectedIndexPath)
    }
    
    /// 內容的Item個數 (假資料)
    /// - Parameter section: Int
    /// - Returns: Int
    func contentItemCount(with section: Int) -> Int {
        return (section + 1) * 10
    }
    
    /// 計算各子分類大項的offset
    /// - Parameter indexPath: IndexPath
    /// - Returns: CGPoint
    func contentViewOffset(with indexPath: IndexPath) -> CGPoint {
        
        var y: CGFloat = 0
        
        (0..<indexPath.row).forEach { section in
            let rowCount = Double(contentItemCount(with: section)) / Double(contentCollectionViewItemCount)
            y += contentCollectionViewHeight.header + contentCollectionViewHeight.item * CGFloat(rowCount._ceiling(toDecimal: 0))
        }
        
        return CGPoint(x: 0, y: y)
    }
    
    /// 設定被選中的ItemCell的背景色
    /// - Parameter indexPath: IndexPath
    func itemCollectionViewSetting(with indexPath: IndexPath) {
        
        let cell = itemCollectionView.cellForItem(at: indexPath) as? ItemCell
        
        ItemCell.selectedIndexPath = indexPath
        
        itemCollectionView.visibleCells.forEach { cell in
            guard let cell = cell as? ItemCell else { return }
            cell.setBackgroundColor()
        }
        
        cell?.setBackgroundColor()
    }
    
    /// 設定被選中的TagCell的背景色
    /// - Parameter indexPath: IndexPath
    func tagCollectionViewSetting(with indexPath: IndexPath) {
        
        if (indexPath == TagCell.selectedIndexPath) { return }
        
        let cell = tagCollectionView.cellForItem(at: indexPath) as? TagCell
        
        TagCell.selectedIndexPath = indexPath
        
        tagCollectionView.visibleCells.forEach { cell in
            guard let cell = cell as? TagCell else { return }
            cell.setBackgroundColor()
        }
        
        cell?.setBackgroundColor()
    }
}

// MARK: - 小工具 for UICollectionViewDataSource
private extension ViewController {
    
    /// 各Section的數量 (假資料)
    /// - Parameter collectionView: UICollectionView
    /// - Returns: Int
    func numberOfSectionsAction(in collectionView: UICollectionView) -> Int {
        
        guard let type = CollectionViewType(rawValue: collectionView.tag) else { return 0 }

        let count: Int
        
        switch type {
        case .item: count = 1
        case .tag: count = 1
        case .content: count = 5
        }
        
        return count
    }
    
    /// 各Section的Item數量 (假資料)
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - section: Int
    /// - Returns: Int
    func collectionViewAction(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let type = CollectionViewType(rawValue: collectionView.tag) else { return 0 }
        
        let number: Int
        
        switch type {
        case .item: number = 20
        case .tag: number = 5
        case .content: number = contentItemCount(with: section)
        }
        
        return number
    }
    
    /// 各Cell的長相
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - indexPath: IndexPath
    /// - Returns: UICollectionViewCell
    func collectionViewAction(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let type = CollectionViewType(rawValue: collectionView.tag) else { fatalError() }

        let cell: UICollectionViewCell & CellReusable
        
        switch type {
        case .item: cell = collectionView._reusableCell(at: indexPath) as ItemCell
        case .tag: cell = collectionView._reusableCell(at: indexPath) as TagCell
        case .content: cell = collectionView._reusableCell(at: indexPath) as ContentCell
        }
        
        cell.configure(with: indexPath)
        
        return cell
    }
    
    /// 設定Header的長相
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - kind: String
    ///   - indexPath: IndexPath
    /// - Returns: UICollectionReusableView
    func collectionViewAction(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == "\(WWCompositionalLayout.ReusableSupplementaryViewKind.header)" {
            let header = collectionView._reusableSupplementaryView(at: indexPath, ofKind: .header) as ReusableHeader
            header.configure(with: indexPath)
            return header
        }
        
        fatalError()
    }
}

// MARK: - 小工具 for UICollectionViewDelegate
private extension ViewController {
    
    /// 被點擊時的反應 (左邊主項目選單 => 右邊全relaod / 右上子項目選單 => 右下內容選單的移動)
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - indexPath: IndexPath
    func collectionViewAction(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let type = CollectionViewType(rawValue: collectionView.tag) else { return }
        
        switch type {
        case .item:
            
            ItemCell.selectedIndexPath = indexPath
            TagCell.selectedIndexPath = IndexPath(row: 0, section: 0)
            
            itemCollectionViewSetting(with: ItemCell.selectedIndexPath)
            
            tagCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
            tagCollectionView.reloadData()
            
            contentCollectionView.setContentOffset(.zero, animated: true)
            contentCollectionView.reloadData()
            
        case .tag:
            
            let offset = contentViewOffset(with: indexPath)

            isSelectItem = true
            tagCollectionViewSetting(with: indexPath)
            contentCollectionView.setContentOffset(offset, animated: true)
            
        case .content: break
        }
    }
    
    /// 滾動時的反應 (同步更新右上角的子項目)
    /// - Parameter scrollView: UIScrollView
    func scrollViewDidScrollAction(_ scrollView: UIScrollView) {
        
        guard let type = CollectionViewType(rawValue: scrollView.tag) else { return }
        
        switch type {
        case .item: break
        case .tag: break
        case .content:
            
            let supplementaryView = contentCollectionView.visibleSupplementaryViews(ofKind: "\(WWCompositionalLayout.ReusableSupplementaryViewKind.header)").min { view1, view2 in
                view1.frame.minY < view2.frame.minY
            }
            
            guard let headerView = supplementaryView as? ReusableHeader else { return }
            
            let offsetY = headerView.frame.minY - scrollView.contentOffset.y
            let isInRange = (-50...50).contains(offsetY)
            
            if (isInRange && !isSelectItem) {
                
                let selectedIndexPath = IndexPath(row: headerView.indexPath.section, section: 0)
                tagCollectionViewSetting(with: selectedIndexPath)
                tagCollectionView.scrollToItem(at: selectedIndexPath, at: .left, animated: true)
            }
        }
    }
    
    /// 處理滾動完成的事件 (防止點擊時滾動，同時也執行滾動的事件處理)
    /// - Parameter scrollView: UIScrollView
    func scrollViewDidEndScrollingAnimationAction(_ scrollView: UIScrollView) {
        
        guard let type = CollectionViewType(rawValue: scrollView.tag) else { return }
        
        switch type {
        case .item: break
        case .tag: break
        case .content: isSelectItem = false
        }
    }
}

// MARK: - UICollectionViewCompositionalLayout
private extension ViewController {
    
    /// 左邊主項目選單的Layout
    /// - Returns: UICollectionViewCompositionalLayout?
    func tableViewLayout() -> UICollectionViewCompositionalLayout? {
        
        let layout = WWCompositionalLayout.shared
            .addItem(width: .fractionalWidth(1.0), height: .absolute(64), contentInsets: edgeInsets, badgeSetting: nil)
            .setGroup(width: .fractionalWidth(1.0), height: .absolute(64), scrollingDirection: .horizontal)
            .setSection(with: .none, contentInsets: contentInsets)
            .build()
        
        return layout
    }
    
    /// 右上子項目選單的Layout
    /// - Parameter count: CGFloat
    /// - Returns: UICollectionViewCompositionalLayout?
    func bookshelfLayout(count: CGFloat = 3.0) -> UICollectionViewCompositionalLayout? {
                
        let layout = WWCompositionalLayout.shared
            .addItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0), contentInsets: edgeInsets, badgeSetting: nil)
            .setGroup(width: .fractionalWidth(1.0/count), height: .fractionalHeight(1.0), scrollingDirection: .vertical)
            .setSection(with: .continuousGroupLeadingBoundary, contentInsets: .zero)
            .build()
        
        return layout
    }
    
    /// 右下子項目內容的Layout
    /// - Returns: UICollectionViewCompositionalLayout?
    func photoAlbumLayout() -> UICollectionViewCompositionalLayout? {
        
        let layout = WWCompositionalLayout.shared
            .addItem(width: .fractionalWidth(1/contentCollectionViewItemCount), height: .absolute(contentCollectionViewHeight.item), contentInsets: edgeInsets)
            .setGroup(width: .fractionalWidth(1.0), height: .absolute(contentCollectionViewHeight.item), scrollingDirection: .horizontal)
            .setSection(with: .none, contentInsets: contentInsets)
            .setHeader(width: .fractionalWidth(1.0), height: .absolute(contentCollectionViewHeight.header))
            .build()
        
        return layout?._register(with: contentCollectionView, supplementaryViewClass: ReusableHeader.self, ofKind: .header)
    }
}
