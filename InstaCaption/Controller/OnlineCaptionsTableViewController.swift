//
//  OnlineCaptionsTableViewController.swift
//  InstaCaption
//
//  Created by Eric Yang on 5/1/19.
//  Copyright © 2019 Eric Yang. All rights reserved.
//

import UIKit

class OnlineCaptionsTableViewController: UITableViewController {

    var captions : [String] = []
    var keys : [String] = []
    
    let backgroundImage = UIImageView(image: UIImage(named: "tableViewBG"))
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.contentMode = .scaleToFill
        tableView.backgroundView = backgroundImage
        print(captions.count)
        if captions.count == 0 {
            getCaptions()
        }
    }
    

    
    
    func getCaptions() {
        // Create Queue and Group
        let backgroundQ = DispatchQueue.global(qos: .background)
        let group = DispatchGroup()
        group.enter()
        backgroundQ.async(group: group, execute: {
        // Enable Background Tasks
            var bTask : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            bTask = UIApplication.shared.beginBackgroundTask {
                () -> Void in
                UIApplication.shared.endBackgroundTask(bTask)
            }
            var request : URLRequest = URLRequest(url: URL(string: "https://hagotem-api.herokuapp.com/api/instaCaption")!)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    print("Had an error \(error)")
                } else {
                    if let data = data {
                        print("Got data")
                        print(data)
                        self.convertJsonDataToDictionary(data)
                    } else {
                        print("NO DATA")
                    }
                }
            })
            task.resume()
        })
        group.leave()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return captions.count
    }
    
    func convertJsonDataToDictionary(_ inputData : Data) {
        guard inputData.count > 1 else{ return }  // avoid processing empty responses
        
        do {
            let dict = try JSONSerialization.jsonObject(with: inputData, options: []) as? Dictionary<String, AnyObject>
            for k in (dict?.keys)! {
                keys.append(k)
            }
            for i in keys {
                captions.append(dict![i] as! String)
            }
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
            
            
        }catch let error as NSError{
            print(error)
            
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = captions[indexPath.row]
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           captions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
