@objc(CropShot)
class CropShot: NSObject {
    
    @objc(captureScreenshot:y:width:height:resolve:reject:) 
    func captureScreenshot(_ x: NSNumber, y: NSNumber, width: NSNumber, height: NSNumber, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                reject("capture_error", "Could not find key window", nil)
                return
            }
            let resizableRectangle = CGRect(x: CGFloat(truncating: x), y: CGFloat(truncating: y), width: CGFloat(truncating: width), height: CGFloat(truncating: height))
            let viewRectangle = CGRect(x: CGFloat(truncating: 0), y: CGFloat(truncating: 0), width: CGFloat(truncating: width), height: CGFloat(truncating: height))
            let rendererRect = CGSize(width: CGFloat(truncating:width), height: CGFloat(truncating:height))
            
            let renderer = UIGraphicsImageRenderer(size: rendererRect)
            let screenshot = renderer.pngData { context in
                keyWindow.resizableSnapshotView(from: resizableRectangle, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)?.drawHierarchy(in: viewRectangle,afterScreenUpdates: true)
            }
            let base64String = screenshot.base64EncodedString()
            resolve(base64String)
        }
    }
    
}
