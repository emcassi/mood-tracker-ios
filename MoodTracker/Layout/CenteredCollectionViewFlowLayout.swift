//
//  CenteredCollectionViewFlowLayout.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/18/24.
//

import Foundation
import UIKit

class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        // Adjust attributes here to center them as a group
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        var rowSizes: [[CGFloat]] = []
        var currentRow: [CGFloat] = []

        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
                if !currentRow.isEmpty {
                    rowSizes.append(currentRow)
                    currentRow.removeAll()
                }
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
            currentRow.append(layoutAttribute.frame.width)
        }
        if !currentRow.isEmpty {
            rowSizes.append(currentRow)
        }

        var startIndex = 0
        for row in rowSizes {
            let rowWidth = row.reduce(0, +) + (CGFloat(row.count - 1) * minimumInteritemSpacing)
            let inset = (collectionView!.bounds.width - rowWidth) / 2
            for i in startIndex..<startIndex+row.count {
                let attribute = attributes![i]
                attribute.frame.origin.x += inset
            }
            startIndex += row.count
        }

        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
