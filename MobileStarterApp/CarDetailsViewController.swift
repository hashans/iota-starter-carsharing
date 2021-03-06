/**
 * Copyright 2016 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import CoreLocation

class CarDetailsViewController: UIViewController {
    
    var car: CarData?
    
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var carDetailsTableView: UITableView!
    
    @IBOutlet weak var reserveCarButton: UIButton!
    
    @IBOutlet weak var carDetailThumbnail: UIImageView!
    
    let sectionHeaderValues = ["Availability", "Specifications", "Reviews"]
    let availabilityLabels = ["Date and time:", "Pick up & drop off at:", "Price:"]
    var availabilityValues = ["", "", ""]
    let specificationsLabels = ["Make and Model:", "Year:", "Mileage:"]
    var specificationsValues: [String] = []
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.backItem?.title = ""
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: localize
        self.title = "Car Details"
        
        self.tabBarController?.tabBar.hidden = true
       
        // Do any additional setup after loading the view.
        self.carNameLabel.text = car?.name
        
        // TODO: localize
        
        self.carDetailThumbnail.image = CarBrowseViewController.thumbnailCache[(car?.thumbnailURL)!]  as? UIImage
        
        ratingLabel.text = String(count: (car?.stars)!, repeatedValue: Character("\u{2605}")) + String(count: (5-(car?.stars)!), repeatedValue: Character("\u{2606}"))
        
        ratingLabel.textColor = UIColor(red: 243/255, green: 118/255, blue: 54/255, alpha: 100)
        
        carDetailsTableView.dataSource = self
        carDetailsTableView.delegate = self
        carDetailsTableView.rowHeight = 20
        carDetailsTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        carDetailsTableView.allowsSelection = true
        carDetailsTableView.allowsMultipleSelection = false
        carDetailsTableView.backgroundColor = UIColor.whiteColor()
        carDetailsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        let pickupDate = NSDate()
        
        availabilityValues[0] = dateFormatter.stringFromDate(pickupDate)
        availabilityValues[0] += " 8:00AM - 10:00PM"
        
        availabilityValues[2] = "$\((car?.hourlyRate)!)/hr, $\((car?.dailyRate)!)/day"
        
        specificationsValues = [(car?.makeModel)!, String("\((car?.year)!)"), thousandSeparator((car?.mileage)!)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func locationButtonAction(sender: AnyObject) {
        showMapAtCarCoordinates()
    }
    
    func showMapAtCarCoordinates() {
        let url : NSURL = NSURL(string: "http://maps.apple.com/maps?q=\((car?.lat)!),\((car?.lng)!)")!
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func thousandSeparator(num: Int) -> String {
        let temp = NSNumberFormatter()
        temp.numberStyle = .DecimalStyle
        
        return temp.stringFromNumber(num)!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let targetController: CreateReservationViewController = segue.destinationViewController as! CreateReservationViewController
        
        targetController.car = car
    }
}

// MARK: - UITableViewDataSource
extension CarDetailsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
         return availabilityLabels.count
        } else if section == 1 {
         return specificationsLabels.count
        } else {
         return 1
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaderValues[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MyIdentifier"
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        cell.contentView.backgroundColor = UIColor.whiteColor()
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.textLabel?.font = UIFont(name: cell.textLabel!.font.fontName, size: 12)
        cell.detailTextLabel?.textColor = UIColor.blackColor()
        cell.detailTextLabel?.font = UIFont(name: cell.textLabel!.font.fontName, size: 12)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if indexPath.section == 0 {
            cell.textLabel?.text = availabilityLabels[indexPath.row]
            if indexPath.row == 1 {
                API.getLocation((car?.lat)!, lng: (car?.lng)!, label: cell.detailTextLabel!)
            } else {
                cell.detailTextLabel?.text = availabilityValues[indexPath.row]
            }
        } else if indexPath.section == 1 {
            cell.textLabel?.text = specificationsLabels[indexPath.row]
            cell.detailTextLabel?.text = specificationsValues[indexPath.row]
        } else {
            cell.textLabel?.text = "No reviews yet"
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CarDetailsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    // to override the grey background and black text on section headers
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let myView = view as! UITableViewHeaderFooterView
        myView.tintColor = UIColor.whiteColor()
        myView.textLabel?.textColor = Colors.dark
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.textLabel?.text == availabilityLabels[1] {
            showMapAtCarCoordinates()
        }
    }
}

