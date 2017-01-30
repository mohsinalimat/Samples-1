//
//  PinterestLayout.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/29/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
}

class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
    var itemHeight: CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PinterestLayoutAttributes
        copy.itemHeight = itemHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if (object as? PinterestLayoutAttributes)?.itemHeight == itemHeight {
            return super.isEqual(object)
        }
        return false
    }
}

class PinterestLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    
    // Keep reference to the delegate
    var delegate: PinterestLayoutDelegate!
    
    // Configure number of columns and cell padding
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6
    
    // This is an array to cache the calculated attributes.
    
    /* When you call prepareLayout(), you’ll calculate the attributes for all items and add them to the cache. When the collection view later requests the layout attributes, you can be efficient and query the cache instead of recalculating them every time
     */
    
    private var cache = [PinterestLayoutAttributes]()
    
    // This declares two properties to store the content size.
    // contentHeight is incremented as photos are added
    private var contentHeight: CGFloat = 0
    
    // contentWidth is calculated based on the collection view width and its content inset.
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    // Variable overrides
    
    /* This overrides collectionViewContentSize variable of the abstract parent class, and returns the size of the collection view’s contents. To do this, you use both contentWidth and contentHeight calculated in the previous steps.
     */
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    /* This overrides layoutAttributesClass variable to tell the collection view to use PinterestLayoutAttributes whenever it creates layout attributes objects.
     */
    
    override class var layoutAttributesClass: AnyClass {
        return PinterestLayoutAttributes.self
    }
    
    // MARK: - Overrides
    
    override func prepare() {
        // Only calculate if cache is empty
        if cache.isEmpty {
            
            /*  This declares and fills the xOffset array with the x-coordinate for every column based on the column widths.
             */
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            
            var xOffset = [CGFloat]()
            
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            
            /*  The yOffset array tracks the y-position for every column. You initialize each value in yOffset to 0, since this is the offset of the first item in each column.
             */
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            // This loops through all the items in the first section, as this particular
            // layout has only one section
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = IndexPath(item: item, section: 0)
                
                // This is where you perform the frame calculation
                // Width is the previously calculated cellWidth, with the padding between cells removed
                let width = columnWidth - cellPadding * 2
                
                // You ask the delegate for the height of the item
                let itemHeight = delegate.collectionView(collectionView!, heightForItemAt: indexPath, with: width)
                
                // Calculate the frame height based on those heights and the predefined cellPadding
                // for the top and bottom
                let height = cellPadding + itemHeight + cellPadding
                
                // Combine this with the x and y offsets of the current column to create the
                // insetFrame used by the attribute
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                // This creates an instance of PinterestLayoutAttributes
                let attributes = PinterestLayoutAttributes(forCellWith: indexPath)
                attributes.itemHeight = itemHeight
                
                // Sets its frame using insetFrame
                attributes.frame = insetFrame
                
                // Append the attributes to cache
                cache.append(attributes)
                
                // This expands contentHeight to account for the frame of the newly calculated item
                contentHeight = max(contentHeight, frame.maxY)
                
                // It then advances the yOffset for the current column based on the frame
                yOffset[column] = yOffset[column] + height
                
                // Finally, it advances the column so that the next item will be placed in the next column.
                if column >= numberOfColumns - 1 {
                    column = 0
                } else {
                    column = column + 1
                }
                
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        //  Iterate through the attributes in cache and check if their frames intersect with rect
        cache.filter { $0.frame.intersects(rect) }.forEach { layoutAttributes.append($0) }
        return layoutAttributes
    }
    
}
