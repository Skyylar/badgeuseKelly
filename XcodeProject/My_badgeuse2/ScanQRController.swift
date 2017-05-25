//
//  ViewController.swift
//  Code Camp
//
//  Created by Vincent DELASSUS on 12/04/2017.
//  Copyright © 2017 Vincent DELASSUS. All rights reserved.
//
import UIKit
import AVFoundation

// Modify properties of the camera instance, it will allow rotations
class CameraView: UIView {
    override class var layerClass: AnyClass {
        get {
            return AVCaptureVideoPreviewLayer.self
        }
    }
    override var layer: AVCaptureVideoPreviewLayer {
        get {
            return super.layer as! AVCaptureVideoPreviewLayer
        }
    }
}

struct login {
    static var tmplogin: String = ""
}

class ScanController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var BarLabel: UINavigationItem!
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    // Camera view
    var iterator = 0
    var LastScan = ""
    var cameraView: CameraView!
    // AV capture session and dispatch queue
    let session = AVCaptureSession()
    let sessionQueue = DispatchQueue(label: AVCaptureSession.self.description(), attributes: [], target: nil)
    let supportedCodeTypes = [AVMetadataObjectTypeQRCode]
    
    override func loadView() {
        // Transform original view to camera view
        cameraView = CameraView()
        view = cameraView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BarLabel.title = promoSelected.promotion
        // Start sessions sttings
        session.beginConfiguration()
        self.prepareCamera()
        self.initLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Start AV capture session
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop AV capture session
        sessionQueue.async {
            self.session.stopRunning()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Update camera orientation
        let videoOrientation: AVCaptureVideoOrientation
        switch UIDevice.current.orientation {
        case .portrait:
            videoOrientation = .portrait
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            videoOrientation = .landscapeRight
        case .landscapeRight:
            videoOrientation = .landscapeLeft
        default:
            videoOrientation = .portrait
        }
        cameraView.layer.connection.videoOrientation = videoOrientation
    }
    
    func prepareCamera() {
        let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
         do {
            if (videoDevice != nil) {
            // Test the camera
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            if (session.canAddInput(videoDeviceInput)) {
                session.addInput(videoDeviceInput)
            }
            // Set only Qr codes to be scaned
            let metadataOutput = AVCaptureMetadataOutput()
            if (session.canAddOutput(metadataOutput)) {
                session.addOutput(metadataOutput)
                metadataOutput.metadataObjectTypes = supportedCodeTypes
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            }
        }
        // Save settings
        session.commitConfiguration()
        cameraView.layer.session = session
        cameraView.layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.camInitPos()
        }
        catch {
            print(error)
            return
        }

    }
    
    func camInitPos() {
        // Set initial camera orientation
        let videoOrientation: AVCaptureVideoOrientation
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            videoOrientation = .portrait
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            videoOrientation = .landscapeLeft
        case .landscapeRight:
            videoOrientation = .landscapeRight
        default:
            videoOrientation = .portrait
        }
        cameraView.layer.connection.videoOrientation = videoOrientation
    }
    
    func initLabel() {
        label.center = CGPoint(x: 90, y: 100)
        label.textAlignment = .center
        label.backgroundColor = UIColor.red
        label.textColor = UIColor.white
        label.font = UIFont(name: label.font.fontName, size: 23)
        label.text = "No Qr detected"
        self.view.addSubview(label)
    }
    
    // Function to dynamically read qr codes
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil.
        if metadataObjects == nil || metadataObjects.count == 0 {
            return
        }
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if supportedCodeTypes.contains(metadataObj.type) {
            if metadataObj.stringValue != nil {
                found(code: metadataObj.stringValue)
            }
        }
    }
    
    func found(code: String) {
        if code != login.tmplogin {
            iterator += 1
            LastScan = code
            // Change the status label
            self.label.backgroundColor = UIColor.yellow
            self.label.text = "Verification ..."
            // Split informations in the qr code
            let login: Array? = code.characters.split(separator: "|").map(String.init)
            // Check if the student belong to the promotion
            if login?[2] == String(describing: promoSelected.idpromotab[promoSelected.id]) {
                self.checkPromo(login: login!)
            }
            else {
                self.label.backgroundColor = UIColor.red
                self.label.text = "Error login"
            }
            
        }
        login.tmplogin = self.LastScan
    }
    
    func checkPromo(login : Array<Any>) {
        let when = DispatchTime.now() + 0
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Prepare and convert string to send to our api
            var promo = String(promoSelected.promotion.characters.filter {$0 != "-"})
            var promo2 = String(promo.characters.filter {$0 != " "})
            let promo3 = String(promo2.characters.filter {$0 != "'"})
            let logine = login[0] as! String
            let url : String = "http://178.62.123.239/api/api.php?update=true&login=\(logine)&promo=\(promo3)"
            if let myUrl = NSURL(string: url) {
                do {
                    _ = try NSString(contentsOf: myUrl as URL, encoding: String.Encoding.utf8.rawValue)
                    self.label.backgroundColor = UIColor.green
                    self.label.text = logine
                    let when = DispatchTime.now() + 3 // change 2 to desired number of seconds
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.label.backgroundColor = UIColor.red
                        self.label.text = "Next ..."
                        self.LastScan = ""
                    }
                }
                catch {
                    print(error)
                }
            }
            else {
                self.label.backgroundColor = UIColor.red
                self.label.text = "Error Url"
            }
        }
    }
}
