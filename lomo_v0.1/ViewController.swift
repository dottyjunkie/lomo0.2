//
//  ViewController.swift
//  lomo_v0.1
//
//  Created by 吳大均 on 2020/3/26.
//  Copyright © 2020 turing-junkie. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage
//import PixelEngine
//import PixelEditor
///
let nameLUT = "lut_fuji.png"

///
class ViewController: UIViewController {

    var session : AVCaptureSession?
    var videopreviewlayer : AVCaptureVideoPreviewLayer?
    var carmera = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
    var capturePhotoOutput : AVCapturePhotoOutput?
    
    @IBOutlet weak var cameraview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let captureDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)

               do{
                   let input = try AVCaptureDeviceInput(device : captureDevice!)

                   session = AVCaptureSession()
                   session?.addInput(input)

                   videopreviewlayer = AVCaptureVideoPreviewLayer(session : session!)
                   videopreviewlayer?.frame = view.layer.bounds
                   cameraview.layer.addSublayer(videopreviewlayer!)
                   session?.startRunning()

               }catch{
                   print("ERROR")
               }
               capturePhotoOutput = AVCapturePhotoOutput()
               capturePhotoOutput?.isHighResolutionCaptureEnabled = true
               session?.addOutput(capturePhotoOutput!)
    }


    @IBAction func takephoto(_ sender: Any) {
        guard let capturePhotoOutput = self.capturePhotoOutput else {
             return
         }
         let photosettings = AVCapturePhotoSettings()
         photosettings.isHighResolutionPhotoEnabled = true
         photosettings.isAutoStillImageStabilizationEnabled = true
         //debug pass
         capturePhotoOutput.capturePhoto(with: photosettings, delegate: self )
    }
}

extension ViewController : AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer : CMSampleBuffer?,
                     previewPhoto previewphotoSampleBuffer : CMSampleBuffer?,
                     resolvedSettings : AVCaptureResolvedPhotoSettings,
                     bracketSettings brackestSettings : AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        guard error == nil,
           let photoSampleBuffer = photoSampleBuffer else {
            print("ERROR")
            return
        }
        
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(

            forJPEGSampleBuffer: photoSampleBuffer,
            previewPhotoSampleBuffer: previewphotoSampleBuffer) else {
            return
        }

        
        let captureImage = UIImage.init(data : imageData,
                                        scale: 1.0)
        

        if let image = captureImage{
            
//            let ci = UIImage(named: "lut_fuji.png")?.cgImage
            let cg = image.cgImage
            let ci = CIImage.init(cgImage: cg!)
            //
            
            //
            let out = convert(cimage: ci)
            UIImageWriteToSavedPhotosAlbum(out, nil, nil, nil)
            
        }
        
    }
}

// let lut = UIImage(named: "lut_fuji.png")
func convert(cimage:CIImage) -> UIImage
{
    let context:CIContext = CIContext.init(options: nil)
    let cgImage:CGImage = context.createCGImage(cimage, from: cimage.extent)!
    let image:UIImage = UIImage.init(cgImage: cgImage)
    return image

}
///////

