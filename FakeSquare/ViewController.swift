//
//  ViewController.swift
//  FakeSquare
//
//  Created by alexk wix on 7/17/17.
//  Copyright © 2017 xxllexx. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let kCustomURLScheme = "pos://"
    
    var pickerData = [
        "amount_invalid_format",
        "amount_too_large",
        "amount_too_small",
        "client_not_authorized_for_user",
        "could_not_perform",
        "currency_code_mismatch",
        "currency_code_missing",
        "customer_management_not_supported",
        "data_invalid",
        "invalid_customer_id",
        "invalid_tender_type",
        "no_network_connection",
        "not_logged_in",
        "payment_canceled",
        "unsupported_api_version",
        "unsupported_currency_code",
        "unsupported_tender_type",
        "user_id_mismatch",
        "user_not_active"
    ]
    
    @IBOutlet weak var errorPicker: UIPickerView!
    
//    let kCustomURLScheme = "stores://"
    
//    let kCustomURLScheme = "wix://stores/pos"

    @IBAction func onSuccess(_ sender: Any) {
        sendResponce(false);
    }
    
    @IBAction func onFail(_ sender: Any) {
        sendResponce(true);
    }
    
    @IBAction func goBack(_ sender: Any) {
        sendResponce(true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func sendResponce(_ isFail: Bool) {
        
        let urlData = UrlDataTransfer.sharedInstance.transformedUrl!;
        
        let str = formatUrlData(isFail ? pickerData[errorPicker.selectedRow(inComponent: 0)] : nil)
        
        if (openCustomURLScheme(customURLScheme: "\(urlData["callback_url"] ?? "pos://")?data=\(str.encodeUrl())" )) {
            print("Success")
        } else {
            print("Error")
        }

    }
    
    func formatUrlData(_ error: String?) -> String {
        
        let urlData = UrlDataTransfer.sharedInstance.transformedUrl!;
        
        let data = [
            "transaction_id": "transaction_id",
            "client_transaction_id": "client_transaction_id",
            "error_code": error ?? "",
            "status": error == nil ? "OK" : "ERROR",
            "state": urlData["state"] ?? ""
        ]
        
        do {
            let dict = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted);
            
            return String(bytes: dict, encoding: String.Encoding.utf8) ?? "invalid json"
        } catch {
            print(error.localizedDescription)
        }
        
        return ""
        
    }
    
    func openCustomURLScheme(customURLScheme: String) -> Bool {
        let customURL = URL(string: customURLScheme)!
        if UIApplication.shared.canOpenURL(customURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(customURL)
            } else {
                UIApplication.shared.openURL(customURL)
            }
            return true
        }
        
        return false
    }

}


