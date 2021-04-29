//
//  VisionViewController.swift
//  NeuralNetwork_Homework
//
//  Created by Антон Бушманов on 16.02.2021.
//

import UIKit
import CoreML
import Vision
import ImageIO
import AVFoundation

class VisionViewController: UIViewController {
    var frameForRocket = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "two") else { return }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        let scaleHeight = view.frame.width / image.size.width * image.size.height
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaleHeight)
        view.addSubview(imageView)
        
        let request = VNDetectFaceRectanglesRequest { (request, error) in
            if let error = error {
                print("Failed to detect faces:", error)
                return
            }
            request.results?.forEach({ (result) in
                DispatchQueue.main.async {
                    print(result)
                    
                    guard let faceObservation = result as? VNFaceObservation else { return }
                                        
                    let heigth = scaleHeight * faceObservation.boundingBox.height
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    let y = (scaleHeight * (1 - faceObservation.boundingBox.origin.y) - heigth)
                    let testView = UIView()
                    testView.backgroundColor = .black
                    testView.frame = faceObservation.boundingBox
                    self.view.addSubview(testView)
                    let upEdge = UIView()
                    upEdge.backgroundColor = .yellow
                    upEdge.frame = CGRect(x: x, y: y, width: width, height: 2)
                    self.view.addSubview(upEdge)
                    let downEdge = UIView()
                    downEdge.backgroundColor = .yellow
                    downEdge.frame = CGRect(x: x, y: y + heigth, width: width, height: 2)
                    self.view.addSubview(downEdge)
                    let leftEdge = UIView()
                    leftEdge.backgroundColor = .yellow
                    leftEdge.frame = CGRect(x: x, y: y, width: 2, height: heigth)
                    self.view.addSubview(leftEdge)
                    let rightEdge = UIView()
                    rightEdge.backgroundColor = .yellow
                    rightEdge.frame = CGRect(x: x + width, y: y, width: 2, height: heigth + 2)
                    self.view.addSubview(rightEdge)
                    self.frameForRocket = CGRect(x: x, y: y, width: width, height: heigth)
                }
            })
        }
        
        guard let cgImage = imageView.image?.cgImage else { return }
        
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch let reqErr {
                print("Failed to perform request:", reqErr)
            }
        }
    }

    @IBAction func rocketBtn(_ sender: Any) {
        animateRocket(frame: frameForRocket)
    }
    
    func animateRocket(frame: CGRect){
        let rocket = UIImageView(image: UIImage(named: "rocket"))
        rocket.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rocket.image!.size.width/50, height: rocket.image!.size.height/50))
        rocket.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height)
        let boom = UIImageView(image: UIImage(named: "boom"))
        boom.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: boom.image!.size.width/50, height: boom.image!.size.height/50))
        boom.center = CGPoint(x: frame.origin.x + frame.size.width/2, y: frame.origin.y + frame.size.height/2)
        boom.alpha = 0
        boom.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.addSubview(rocket)
        view.addSubview(boom)
        let distance = view.frame.size.width / min(frame.size.width, frame.size.height)
        let duration = Double(distance) * 0.45
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn) {
            rocket.center = boom.center
        } completion: { (_) in
            rocket.alpha = 0
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut) {
                boom.alpha = 1
                boom.transform = CGAffineTransform(scaleX: 1, y: 1)
            } completion: { (_) in
                UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut) {
                    boom.alpha = 0
                    boom.transform = CGAffineTransform(scaleX: 2, y: 2)
                } completion: { (_) in
                    
                }
            }
        }
    }
}
