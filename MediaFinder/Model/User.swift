//
//  User.swift
//  MediaFinder
//
//  Created by Tolba on 14/05/1444 AH.
//

import UIKit

enum Gender: String, Codable{
    case Male
    case Female
}

struct User: Codable {
    var name: String!
    var email: String!
    var password: String!
    var phone: String!
    var address1: String!
    var address2: String!
    var address3: String!
    var image: Data!
    var gender: Gender!
}

/*
struct CodableImage: Codable {
    let imageData: Data?
    
    init(image: UIImage) {
            self.imageData = image.jpegData(compressionQuality: 0.5)
        }
    
    func getImage() -> UIImage? {
        guard let data = self.imageData else { return nil}
        let image = UIImage(data: data)
        return image
    }
    
    }
*/
