//
//  DataManager.swift
//  SomeApp
//
//  Created by Perry on 3/17/16.
//  Copyright © 2016 PerrchicK. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataManager {
    static var applicationLibraryPath: NSString = {
        if let libraryDirectoryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last {
            return libraryDirectoryPath as NSString
        }
        
        📘("ERROR!! Library directory not found 😱")
        return ""
    }()

    static var applicationDocumentsPath: String = {
        if let libraryDocumentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last {
            return libraryDocumentsPath
        }

        📘("ERROR!! Library directory not found 😱")
        return ""
    }()

    fileprivate static var managedContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.managedObjectContext
    }

    @discardableResult
    static func saveImage(_ imageToSave: UIImage, toFile filename: String) -> Bool {
        if let data = UIImagePNGRepresentation(imageToSave) {
            do {
                let applicationLibraryPathString = (applicationLibraryPath as String)
                try data.write(to: URL(fileURLWithPath: applicationLibraryPathString + "/" + filename), options: .atomicWrite)
                return true
            } catch {
                📘("Failed to save image!")
            }
        }

        return false
    }
    
    static func loadImage(fromFile filename: String) -> UIImage? {
        let applicationLibraryPathString = (applicationLibraryPath as String)
        if let data = try? Data(contentsOf: URL(fileURLWithPath: applicationLibraryPathString + "/" + filename)) {
            return UIImage(data: data)
        }

        return nil
    }
    
    static func createUser() -> User {
        let entity = NSEntityDescription.entity(forEntityName: className(User.self), in: DataManager.managedContext)
        return User(entity: entity!, insertInto: DataManager.managedContext)
    }

    static func syncedUserDefaults() -> SyncedUserDefaults {
        return SyncedUserDefaults.sharedInstance
    }

    static func fetchUsers(_ named: String? = nil) -> [User]? {
        var fetchedUsers: [User]?
        let usersFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: className(User.self))
        
        if named != nil {
            usersFetchRequest.predicate = NSPredicate(format: "firstName == %@", named!)
        }
        
        do {
            fetchedUsers = try managedContext.fetch(usersFetchRequest) as? [User]
        } catch {
            ToastMessage.show(messageText: "Error fetching from Core Data: \(error)")
        }
        
        return fetchedUsers
    }
}
