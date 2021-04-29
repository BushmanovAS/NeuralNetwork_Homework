//
//  PriceViewController.swift
//  NeuralNetwork_Homework
//
//  Created by Антон Бушманов on 16.02.2021.
//

import UIKit
import CoreML
import Vision

class PriceViewController: UIViewController {
    @IBOutlet weak var areaText: UITextField!
    @IBOutlet weak var floorText: UITextField!
    @IBOutlet weak var roomsText: UITextField!
    @IBOutlet weak var latitudeText: UITextField!
    @IBOutlet weak var longirudeText: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    let model = ApartmentsPricer()
    
    @IBAction func btn(_ sender: Any) {
        let area = Double(areaText.text!) ?? 0.0
        let floor = Double(floorText.text!) ?? 0.0
        let rooms = Double(roomsText.text!) ?? 0.0
        let latitude = Double(latitudeText.text!) ?? 0.0
        let longitude = Double(longirudeText.text!) ?? 0.0
        let prediction = try? model.prediction(
            Area: area,
            Floor: floor,
            Rooms: rooms,
            Latitude: latitude,
            Longitude: longitude)
        let price = prediction?.Price
        priceLabel.text = String(Int(price!)) + " $"
    }
}
