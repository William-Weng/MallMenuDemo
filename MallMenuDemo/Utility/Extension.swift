//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2024/8/6.
//

import UIKit
import WWCompositionalLayout

// MARK: - Double (function)
extension Double {
    
    /// 無條件進位至 小數第x位
    /// - 123.45678 => 123.45
    /// - Parameter decimal: 要轉換的小數
    /// - Returns: Double
    func _ceiling(toDecimal decimal: Int) -> Double {
        
        let numberOfDigits = abs(pow(10.0, Double(decimal)))
        
        if (self.sign == .minus) { return Double(Int(self * numberOfDigits)) / numberOfDigits }
        return Double(ceil(self * numberOfDigits)) / numberOfDigits
    }
}

// MARK: - CALayer (function)
extension CALayer {
    
    /// [設定圓角](https://www.appcoda.com.tw/calayer-introduction/)
    /// - [可以個別設定要哪幾個角 / 預設是四個角全是圓角](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/讓-view-變圓角的-layer-cornerradius-54aa7afda2a1)
    /// - Parameters:
    ///   - radius: 圓的半徑
    ///   - masksToBounds: Bool
    ///   - corners: 圓角要哪幾個邊
    func _maskedCorners(radius: CGFloat, masksToBounds: Bool = true, corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]) {
        self.masksToBounds = masksToBounds
        self.maskedCorners = corners
        self.cornerRadius = radius
    }
}

// MARK: - UICollectionView (function)
extension UICollectionView {
    
    /// 初始化Protocal
    /// - Parameter this: UICollectionViewDelegate & UICollectionViewDataSource
    func _delegateAndDataSource(with this: UICollectionViewDelegate & UICollectionViewDataSource) {
        self.delegate = this
        self.dataSource = this
    }
    
    /// 清除Protocal
    func _removeDelegateAndDataSource() {
        self.delegate = nil
        self.dataSource = nil
    }
    
    /// 隱藏滾動條
    /// - Parameter isHidden: Bool
    func _hideScrollIndicator(_ isHidden: Bool = true) {
        showsHorizontalScrollIndicator = !isHidden
        showsVerticalScrollIndicator = !isHidden
    }
    
    /// 取得UICollectionViewCell
    /// - let cell = collectionView._reusableCell(at: indexPath) as MyCollectionViewCell
    /// - Parameter indexPath: IndexPath
    /// - Returns: 符合CellReusable的Cell
    func _reusableCell<T: CellReusable>(at indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else { fatalError("UICollectionViewCell Error") }
        return cell
    }
    
    /// 註冊Cell (使用xib / code)
    /// - Parameters:
    ///   - cellClass: 符合CellReusable的Cell
    ///   - kind: String
    func  _registerSupplementaryView<T: CellReusable>(cellClass: T.Type, ofKind kind: WWCompositionalLayout.ReusableSupplementaryViewKind) {
        register(T.self, forSupplementaryViewOfKind: "\(kind)", withReuseIdentifier: T.identifier)
    }
    
    /// 取得UICollectionReusableView
    /// - let header = collectionView._reusableHeader(at: indexPath, forKind = .header) as MyCollectionReusableHeader
    /// - Parameters:
    ///   - indexPath: IndexPath
    ///   - kind: Constant.ReusableSupplementaryViewKind
    /// - Returns: 符合CellReusable的ReusableView
    func _reusableSupplementaryView<T: CellReusable>(at indexPath: IndexPath, ofKind kind: WWCompositionalLayout.ReusableSupplementaryViewKind) -> T where T: UICollectionReusableView {
        guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: "\(kind)", withReuseIdentifier: T.identifier, for: indexPath) as? T else { fatalError("UICollectionReusableView Error") }
        return supplementaryView
    }
    
    /// [資料新增或刪除時的動作設定 - performBatchUpdates() => beginUpdates() + endUpdates()](https://ithelp.ithome.com.tw/articles/10225747)
    /// - Parameters:
    ///   - updates: [(() -> Void)?](https://medium.com/@howardsun/uicollectionview-performbatchupdates-最大的秘密-7fb214c81d17)
    ///   - completion: [((Bool) -> Void)?](https://developer.apple.com/documentation/uikit/uicollectionview/1618045-performbatchupdates)
    func _performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        
        self.performBatchUpdates {
            updates?()
        } completion: { isCompleted in
            completion?(isCompleted)
        }
    }
}

// MARK: - UICollectionViewLayout (function)
extension UICollectionViewCompositionalLayout {
        
    func _register<T: CellReusable>(with collectionView: UICollectionView, supplementaryViewClass: T.Type, ofKind kind: WWCompositionalLayout.ReusableSupplementaryViewKind) -> Self {
        collectionView._registerSupplementaryView(cellClass: supplementaryViewClass, ofKind: kind)
        return self
    }
    
    func _register(with viewClass: AnyClass?, ofKind kind: WWCompositionalLayout.ReusableSupplementaryViewKind) -> Self {
        self.register(viewClass, forDecorationViewOfKind: "\(kind)")
        return self
    }
}
