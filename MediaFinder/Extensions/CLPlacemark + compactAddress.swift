//
//  CLPlacemark + compactAddress.swift
//  MediaFinder
//
//  Created by Tolba on 28/05/1444 AH.
//

import MapKit

extension CLPlacemark {
    var compactAddress: String? {
        var result: String = ""
        if let name = name {
            result += name
        }
        if let street = thoroughfare {
            result += ", \(street)"
        }
        if let city = locality {
            result += ", \(city)"
        }
        if let country = country {
            result += ", \(country)"
        }
        return result
    }
}
