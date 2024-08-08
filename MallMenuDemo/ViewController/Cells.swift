//
//  File.swift
//  Example
//
//  Created by William.Weng on 2024/8/6.
//

import UIKit
import WWPrint

final class ItemCell: UICollectionViewCell, CellReusable {
    
    static let colors1: [UIColor] = [.systemRed, .green, .magenta, .systemPink, .orange]
    static let colors2: [UIColor] = [.green, .magenta, .orange, .purple, .systemPink]
    
    static var selectedIndexPath: IndexPath = .init()
    
    var indexPath: IndexPath = .init()
    
    @IBOutlet weak var titleLabel: UILabel!
        
    func configure(with indexPath: IndexPath) {
        self.indexPath = indexPath
        titleLabel.text = "分類\(indexPath.row + 1)"
        setBackgroundColor()
    }
    
    func setBackgroundColor() {
        backgroundColor = (indexPath == Self.selectedIndexPath) ? .yellow : .yellow.withAlphaComponent(0.3)
    }
}

final class TagCell: UICollectionViewCell, CellReusable {
    
    static var selectedIndexPath: IndexPath = .init()
    
    var indexPath: IndexPath = .init()
    
    @IBOutlet weak var titleLabel: UILabel!
        
    func configure(with indexPath: IndexPath) {
        
        self.indexPath = indexPath

        layer._maskedCorners(radius: 26)
        titleLabel.text = "分類\(ItemCell.selectedIndexPath.row + 1) - 細項\(indexPath.row + 1)"
        setBackgroundColor()
    }
    
    func setBackgroundColor() {
        backgroundColor = ItemCell.colors1[ItemCell.selectedIndexPath.row % ItemCell.colors1.count]
        if (indexPath != Self.selectedIndexPath) { backgroundColor = backgroundColor?.withAlphaComponent(0.3) }
    }
}

final class ContentCell: UICollectionViewCell, CellReusable {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with indexPath: IndexPath) {
        titleLabel.text = "分類\(ItemCell.selectedIndexPath.row + 1) - 內容\(indexPath.row + 1)"
    }
    
    func setBackgroundColor() {
        backgroundColor = ItemCell.colors2[ItemCell.selectedIndexPath.row % ItemCell.colors2.count]
    }
}
