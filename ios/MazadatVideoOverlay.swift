
import Foundation
import UIKit
@objc(MazadatVideoOverlay)
class MazadatVideoOverlay: NSObject {

  @objc
  func multiply(_ a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) {
      
    resolve(a+b)
  }
    
    @objc
    func playVideo(_ link: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) {
        DispatchQueue.main.async{
            let controller=VideoPlayerController()
            controller.setLink(link: link)
            controller.modalPresentationStyle = .overCurrentContext
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(controller, animated: true, completion: nil)
        }
      
    }
}
