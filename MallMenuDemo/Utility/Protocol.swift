//
//  Protocol.swift
//  MallMenuDemo
//
//  Created by iOS on 2024/8/7.
//

import UIKit

// MARK: - 可重複使用的Cell (UITableViewCell / UICollectionViewCell)
protocol CellReusable: AnyObject {
    
    static var identifier: String { get }           /// Cell的Identifier
    var indexPath: IndexPath { get }                /// Cell的IndexPath
    
    /// Cell的相關設定
    /// - Parameter indexPath: IndexPath
    func configure(with indexPath: IndexPath)
    
    /// 設定背景色
    func setBackgroundColor()
}

// MARK: - 預設 identifier = class name (初值)
extension CellReusable {
    static var identifier: String { return String(describing: Self.self) }
    var indexPath: IndexPath { return [] }
}

// MARK: - 載入Xib的Protocol
protocol NibOwnerLoadable: AnyObject {
    static var nibName: String { get }
    static var nib: UINib { get }
}

// MARK: - 直接設定初值
extension NibOwnerLoadable {
    static var nibName: String { Self.nibNameMaker() }
    static var nib: UINib { Self.nibMaker() }
}

// MARK: - 開放使用的function
extension NibOwnerLoadable where Self: UIView {

    /// 載入XibView (加上constraint)
    func loadViewFromXib() {
        guard let contentView = xibContentViewMaker() else { fatalError("載入XibView失敗") }
        addSubview(contentView)
        xibConstraintSetting(contentView: contentView)
    }
}

// MARK: - 小工具
extension NibOwnerLoadable {

    /// 取得xib的name
    /// - Returns: String
    private static func nibNameMaker() -> String { return String(describing: Self.self) }
    
    /// 讀取xib
    /// - Returns: UINib
    private static func nibMaker() -> UINib { return UINib(nibName: nibNameMaker(), bundle: Bundle(for: Self.self)) }

    /// 取得xib的contentView
    /// - Returns: UIView?
    private func xibContentViewMaker() -> UIView? {

        guard let views = Self.nib.instantiate(withOwner: self, options: nil) as? [UIView],
              let contentView = views.first
        else {
            return nil
        }

        return contentView
    }
}

// MARK: - 小工具 (UIView)
extension NibOwnerLoadable where Self: UIView {
    
    /// 設定xib的constraint
    /// - Parameter contentView: 要加上去的View
    private func xibConstraintSetting(contentView: UIView) {

        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
