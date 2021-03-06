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

import Foundation
import MapKit
 
class CarData: NSObject, MKAnnotation {
	var deviceID: String?
	var deviceType: String?
	var lastUpdateTime: Int?
	var lat: Double?
	var lng: Double?
	var name: String?
	var status: String?
	var distance: Int?
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var makeModel: String?
    var year: Int?
    var mileage: Int?
    var availability: String?
    var stars: Int?
    var hourlyRate: Int?
    var dailyRate: Int?
    var thumbnailURL: String?
    var type: String?
    var drive: String?
    var license: String?
    
    var rate: Double?
    var rateCauseCategory: String?
    var rateCauseShort: String?
    var rateCauseLong: String?

    class func fromDictionary(array:NSArray) -> [CarData] {
        var returnArray:[CarData] = []
        for item in array {
            returnArray.append(CarData(dictionary: item as! NSDictionary))
        }
        
        return returnArray
    }

	init(dictionary: NSDictionary) {
		deviceID = dictionary["deviceID"] as? String
		deviceType = dictionary["deviceType"] as? String
		lastUpdateTime = dictionary["lastUpdateTime"] as? Int
        if let latValue = dictionary["lat"] as? String {
            lat = Double(latValue)
        } else {
            lat = dictionary["lat"] as? Double
        }
        if let lngValue = dictionary["lng"] as? String {
            lng = Double(lngValue)
        } else {
            lng = dictionary["lng"] as? Double
        }
		name = dictionary["name"] as? String
		status = dictionary["status"] as? String
		distance = dictionary["distance"] as? Int
        license = dictionary["license"] as? String
        
        if let latTemp = lat, longTemp = lng {
            coordinate = CLLocationCoordinate2D(latitude: latTemp, longitude: longTemp)
        } else {
            coordinate = CLLocationCoordinate2D()
        }
        title = name
        
        if let model = dictionary["model"] {
            makeModel = model["makeModel"] as? String
            year = model["year"] as? Int
            mileage = model["mileage"] as? Int
            stars = model["stars"] as? Int
            hourlyRate = Int((model["hourlyRate"] as? Double)!)
            dailyRate = Int((model["dailyRate"] as? Double)!)
            thumbnailURL = model["thumbnailURL"] as? String
            type = model["type"] as? String
            drive = model["drive"] as? String
        }
        
        if let recommendation = dictionary["recommendation"] {
            rate = recommendation["rate"] as? Double
            
            if let causes = recommendation["causes"] {
                if causes?.count > 0 {
                    rateCauseCategory = causes![0]["category"] as? String
                    rateCauseShort = causes![0]["shortText"] as? String
                    rateCauseLong = causes![0]["longText"] as? String
                }
            }
        }
        
	}
}