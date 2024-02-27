//
//  ViewController.swift
//  ExAlamofire
//
//  Created by RLogixxTraining on 26/02/24.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    var url = "https://rashitalk.com/api/login"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    var properties: [Property] = []
    struct Property {
        let id: Int
        let propertytype: String
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func btnPost(_ sender: Any) {
        
        let parameters: [String: Any] = [
            "email": txtEmail.text!,
            "password": txtPassword.text!
        ]
        
        AF.request(url, method: .post, parameters: parameters)
            .validate(statusCode: 200..<300) // Validate that the status code is in the range 200-299
            .validate(contentType: ["application/json"]) // Validate that the content type is JSON
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Response JSON: \(value)")
                    // Handle successful response, such as checking login status
                case .failure(let error):
                    print("Error: \(error)")
                    // Handle failure, such as network error or invalid response
                }
            }
        
        
       
       
    }
    
    
    
    
    @IBAction func btnGet(_ sender: Any) {

        fetchData()
        //        let apiUrl = "https://rashitalk.com/api/propertydata"
//        let email = "propertyagent@gmail.com"
//
//                // Define the parameters for the GET request
//                let parameters: [String: Any] = [
//                    "email": email
//                ]
//
//                // Send a GET request with parameters
//                AF.request(apiUrl, method: .get, parameters: parameters)
//                    .validate(statusCode: 200..<300) // Validate that the status code is in the range 200-299
//                    .validate(contentType: ["application/json"]) // Validate that the content type is JSON
//                    .responseJSON { response in
//                        switch response.result {
//                        case .success(let value):
//                            print("Response JSON: \(value)")
//                            // Handle successful response, such as parsing the JSON data
//                        case .failure(let error):
//                            print("Error: \(error)")
//                            // Handle failure, such as network error or invalid response
//                        }
//                    }
            }
    
    func fetchData() {
            let apiUrl = "https://rashitalk.com/api/propertydata?email=propertyagent@gmail.com"
            
            AF.request(apiUrl)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        // Parse JSON response and update table view
                        if let jsonArray = value as? [[String: Any]] {
                            self.properties = jsonArray.compactMap { dictionary in
                                guard let id = dictionary["id"] as? Int,
                                      let propertytype = dictionary["propertytype"] as? String else {
                                    return nil
                                }
                                return Property(id: id, propertytype: propertytype)
                            }
                            // Reload the table view with fetched data
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
        }
    }
        

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
              let property = properties[indexPath.row]
              cell.textLabel?.text = property.propertytype
              cell.detailTextLabel?.text = "\(property.id)"
              return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
   
    
    
    
    
    
}
    


