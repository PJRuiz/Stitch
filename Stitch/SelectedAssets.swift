

import UIKit
import Photos

class SelectedAssets: NSObject {
  var assets: [PHAsset]
  
  override init() {
    assets = []
  }
  
  init(assets:[PHAsset]) {
    self.assets = assets
  }
  
}
