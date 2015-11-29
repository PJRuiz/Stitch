
import UIKit
import Photos

let StitchEditSegueID = "StitchEditSegue"

class StitchDetailViewController: UIViewController, PHPhotoLibraryChangeObserver, AssetPickerDelegate {
  
  var asset: PHAsset!
  
  @IBOutlet private var imageView: UIImageView!
  
  @IBOutlet private var editButton: UIBarButtonItem!
  @IBOutlet private var favoriteButton: UIBarButtonItem!
  @IBOutlet private var deleteButton: UIBarButtonItem!
  
  private var stitchAssets:[PHAsset]?
  
  deinit {
    // Unregister observer
		PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
  }
  
  // MARK: UIViewController
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Register observer
		PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
  }
  
  override func viewWillAppear(animated: Bool)  {
    super.viewWillAppear(animated)
    
    displayImage()
    
    // Update the interface buttons
		
		editButton.enabled = asset.canPerformEditOperation(.Content)
		favoriteButton.enabled = asset.canPerformEditOperation(.Properties)
		deleteButton.enabled = asset.canPerformEditOperation(.Delete)
		updateFavoriteButton()
		
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if segue.identifier == StitchEditSegueID {
      let nav = segue.destinationViewController as! UINavigationController
      let dest = nav.viewControllers[0] as! AssetCollectionsViewController
      dest.delegate = self
      
      // Set up AssetPickerTableViewController
			if let assets = stitchAssets {
				dest.selectedAssets = SelectedAssets(assets: assets)
			} else {
				dest.selectedAssets = nil
			}
      
    }
  }
  
  // MARK: Private
  private func displayImage() {
    // Load a high quality image to display
		let scale = UIScreen.mainScreen().scale
		let targetSize = CGSize(width: CGRectGetWidth(imageView.bounds) * scale, height: CGRectGetHeight(imageView.bounds) * scale)
		let options = PHImageRequestOptions()
		options.deliveryMode = .HighQualityFormat
		options.networkAccessAllowed = true
		
		PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: targetSize, contentMode: .AspectFill, options: options) { result, info in
			if ( result != nil ) {
				self.imageView.image = result
			}
		}
  }
  
  private func updateFavoriteButton() {
    if asset.favorite {
      favoriteButton.title = "Unfavorite"
    } else {
      favoriteButton.title = "Favorite"
    }
  }
  
  // MARK: Actions
  @IBAction func favoritePressed(sender:AnyObject!) {
		
		PHPhotoLibrary.sharedPhotoLibrary().performChanges ({
			let request = PHAssetChangeRequest(forAsset: self.asset)
			request.favorite = !self.asset.favorite
		}, completionHandler: nil )
    
  }
  
  @IBAction func deletePressed(sender:AnyObject!) {
    PHPhotoLibrary.sharedPhotoLibrary().performChanges({
			PHAssetChangeRequest.deleteAssets([self.asset])
			
			}, completionHandler: nil)
  }
  
  @IBAction func editPressed(sender:AnyObject!) {
    // Load the selected stitches then perform the segue to the picker
		StitchHelper.loadAssetsInStitch(asset) { stitchAssets in
			self.stitchAssets = stitchAssets
			dispatch_async(dispatch_get_main_queue()) {
				self.performSegueWithIdentifier(StitchEditSegueID,
					sender: self)
			}
		}
  }
	
	
  // MARK: AssetPickerDelegate
  
  func assetPickerDidCancel() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func assetPickerDidFinishPickingAssets(selectedAssets: [PHAsset])  {
    dismissViewControllerAnimated(true, completion: nil)
    
    // Update stitch with new assets
		let stitchImage = StitchHelper.createStitchImageWithAssets(selectedAssets)
		StitchHelper.editStitchContentWith(self.asset, image: stitchImage, assets: selectedAssets)
  }
  
  
  // MARK: PHPhotoLibraryChangeObserver
  func photoLibraryDidChange(changeInstance: PHChange)  {
    // Respond to changes
		dispatch_async(dispatch_get_main_queue()) {
			if let changeDetails = changeInstance.changeDetailsForObject(self.asset) {
				if changeDetails.objectWasDeleted {
					self.navigationController?.popViewControllerAnimated(true)
					return
				}
				self.asset = changeDetails.objectAfterChanges as! PHAsset
				if changeDetails.assetContentChanged {
					self.displayImage()
				}
				self.updateFavoriteButton()
			}
		}
  }
}
