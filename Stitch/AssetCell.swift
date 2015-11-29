

import UIKit

class AssetCell: UICollectionViewCell {
  
  @IBOutlet var imageView: UIImageView!
  var reuseCount: Int = 0
  
  @IBOutlet private var checkMark: UIView?
  
  override var selected: Bool {
    didSet {
      checkMark?.hidden = !selected
    }
  }
}
