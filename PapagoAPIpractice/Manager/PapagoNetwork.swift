//
//  PapagoNetwork.swift
//  PapagoAPIpractice
//
//  Created by LOUIE MAC on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON


struct PapagoNetwork {
    
    static let shared = PapagoNetwork()
    private init() {}
    
    let picker = UIPickerView()
    let sensorURL = PapagoAPI.papagoLanguageSensorURL
    let translationURL = PapagoAPI.papagoTranslationURL
    let sensorHeaders:HTTPHeaders = [
        HeadersforSensor.ClientID,
        HeadersforSensor.ClientSecret,
        HeadersforSensor.ContentType
    ]
    
    let translationHeaders:HTTPHeaders = [
        HeadersforTranslation.ClientID,
        HeadersforTranslation.ClientSecret,
        HeadersforTranslation.ContentType
    ]
    
    func fetchSensorRequest(sensorParams: Parameters,complition: @escaping (String?)-> Void) {
        AF.request(sensorURL, method: .post, parameters: sensorParams, headers: sensorHeaders).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let langCode = json["langCode"].stringValue
                
                complition(langCode)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    func fetchTranslationRequest(translationParam: Parameters,complition: @escaping (String?)-> Void) {
        AF.request(translationURL, method: .post, parameters: translationParam,headers: translationHeaders).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let resultText = json["message"]["result"]["translatedText"].stringValue
                print("네트워크 번역결과 : \(resultText)")
                complition(resultText)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
