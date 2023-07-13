//
//  ViewController.swift
//  machineLearning
//
//  Created by Murathan karagöz on 10.07.2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
 

    var choosenİmage = CIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
    }

    
    
    @IBAction func changeButton(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        if let ciİmage = CIImage(image: imageView.image!) {
            choosenİmage = ciİmage
        }
        recognizeImage(image: choosenİmage)
        
        
    }
    
    func recognizeImage(image: CIImage) {
            
            // 1) Request
            // 2) Handler
            
            infoLabel.text = "Finding ..."
            
            if let model = try? VNCoreMLModel(for: MobileNetV2().model) {
                let request = VNCoreMLRequest(model: model) { (vnrequest, error) in
                    
                    if let results = vnrequest.results as? [VNClassificationObservation] {
                        if results.count > 0 {
                            
                            let topResult = results.first
                            
                            DispatchQueue.main.async {
                                //
                                let confidenceLevel = (topResult?.confidence ?? 0) * 100
                                
                                let rounded = Int (confidenceLevel * 100) / 100
                                
                                self.infoLabel.text = "\(rounded)% it's \(topResult!.identifier)"
                                
                            }
                            
                        }
                        
                    }
                    
                }
                let handler = VNImageRequestHandler(ciImage: image)
                                 DispatchQueue.global(qos: .userInteractive).async {
                                   do {
                                   try handler.perform([request])
                                   } catch {
                                       print("error")
                                   }
                           }
                           
                           
                       }
                       
                     
                       
                   }
                   
    
}

