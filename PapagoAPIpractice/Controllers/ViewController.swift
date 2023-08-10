//
//  ViewController.swift
//  PapagoAPIpractice
//
//  Created by LOUIE MAC on 2023/08/10.
//

import UIKit
import Alamofire


final class ViewController: UIViewController {
    
    let networkManamger = PapagoNetwork.shared
    
    @IBOutlet weak var originLangLabel: UILabel!
    @IBOutlet weak var targetLangLabel: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var targetTextView: UITextView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    var isEditingStarted:Bool = false
    
    var sensorParam:Parameters {
        return [ "query" : inputTextView.text ?? "" ]
    }
    
    var translateParam: Parameters {
        return [
            "source":"ko",
            "target":"en",
            "text" : inputTextView.text ?? ""
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettings()
    }
    
    private func setupSettings() {
        inputTextView.delegate = self
        targetTextView.isEditable = false
        placeHolderLabel.isHidden = false
        targetTextView.isHidden = true
        originLangLabel.text = "언어감지"
        targetLangLabel.text = "영어"
    }
    
    
    private func suggestLanguageCode(langCode: String)->String {
        switch langCode {
        case "ko": return "한국어"
        case "ja": return "일본어"
        case "zh-CN": return "중국어 간체"
        case "zh-TW": return "중국어 번체"
        case "hi": return "힌디어"
        case "en": return "영어"
        case "es": return "스페인어"
        case "fr": return "프랑스어"
        case "de": return "독일어"
        case "pt": return "포르투갈어"
        case "vi": return "베트남어"
        case "id": return "인도네시아어"
        case "fa": return "페르시아어"
        case "ar": return "아랍어"
        case "mm": return "미얀마어"
        case "th": return "태국어"
        case "ru": return "러시아어"
        case "it": return "이탈리아어"
        default: return "알 수 없음"
        }
    }
    
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        networkManamger.fetchTranslationRequest(translationParam: translateParam) { [weak self] resultText in
            self?.targetTextView.text = resultText
        }
        print(#function)
        targetTextView.isHidden = false
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        inputTextView.text = ""
        targetTextView.text = ""
        originLangLabel.text = "언어감지"
        targetTextView.isHidden = true
//        inputTextView.becomeFirstResponder()
    }
    
    
    
    
}




extension ViewController:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard !inputTextView.text.isEmpty else {
            isEditingStarted = false
            inputTextView.text = ""
            return
        }
        
        if !isEditingStarted {
            isEditingStarted = true
            networkManamger.fetchSensorRequest(sensorParams: sensorParam) { [weak self] langCode in
                guard let langCode = langCode else {
                    print("언어가 감지되지 않습니다.")
                    return
                }
                self?.originLangLabel.text = self?.suggestLanguageCode(langCode: langCode)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderLabel.isHidden = true
//        inputTextView.becomeFirstResponder()
    }
}
