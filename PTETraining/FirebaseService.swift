//
//  DataService.swift
//  Managee
//
//  Created by Fan Wu on 11/22/16.
//  Copyright © 2016 8184. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

let dbService = FirebaseService()
private let speakingDIPractices = "Speaking/DI/Practices"
private let speakingDITipsPath = "Speaking/DI/DITips.docx"
private let speakingRLPractices = "Speaking/RL/Practices"
private let speakingRLTipsPath = "Speaking/RL/RLTips.docx"
private let speakingRAPractices = "Speaking/RA/Practices"
private let speakingRATipsPath = "Speaking/RA/RATips.docx"
private let speakingASQPractices = "Speaking/ASQ/Practices"
private let speakingASQTipsPath = "Speaking/ASQ/ASQTips.docx"
private let speakingRSPractices = "Speaking/RS/Practices"
private let speakingRSTipsPath = "Speaking/RS/RSTips.docx"
private let listeningFBPractices = "Listening/FB/Practices"
private let listeningFBTipsPath = "Listening/FB/FBTips.docx"

class FirebaseService {
    
    struct Constants {
        //general
        static let imagePostfix = ".jpg"
        static let status = "status"
        static let order = "order"
        
        //error
        static let undefinedErrorsNode = "undefinedErrors"
        static let time = "Time"
        
        //profile
        static let profile = "profile"
        static let name = "name"
        static let imageURL = "imageURL"
        
        //group
        static let groupsNode = "groups"
        static let groupsImagesFolderName = "groupsImages"
        static let createrUid = "createrUid"
        static let managersUid = "managersUid"
        static let members = "members"
        static let isManager = "isManager"
        static let aids = "aids"
        
        //activity
        static let activitiesNode = "activities"
        static let activitiesImagesFolderName = "activitiesImages"
        static let signUpMemberIDs = "signUpMemberIDs"
    }
    
    static var autoID: String { return FIRDatabase.database().reference().childByAutoId().key }
    private var databaseRef: FIRDatabaseReference { return FIRDatabase.database().reference() }
    private var storageRef: FIRStorageReference { return FIRStorage.storage().reference() }
    private let errorMsgDictionary = [
        //sign in error
        17999: "Invalid Email Form.",
        17011: "The Email Account Has Not Sign Up Yet.",
        17009: "Wrong Password.",
        
        //sign up error
        17007: "The Email Account Is Already In Use.",
        17008: "Invalid Email Form.",
        17026: "The Password Should Be At Least 6 Characters",
        
        //storage error
        -13010: "The File Does Not Exist"
    ]

    //-----------------------------------------POPULATING---------------------------------------------------------
    func getFilesURL(directory: String, numberOfFiles: Int, prefixOfFile: String, fileNumber: Int = 0, suffixOfFile: String, eashSuccessfulCompletion: @escaping (String) -> Void, afterAllDone: @escaping () -> Void) {
        if fileNumber < numberOfFiles {
            let filename = prefixOfFile + "\(fileNumber)" + suffixOfFile
            let diFileRef = storageRef.child(directory).child(filename)
            diFileRef.downloadURL { url, error in
                if let err = error {
                    print(err)
                } else if let dlURL = url?.absoluteString {
                    print(dlURL)
                    eashSuccessfulCompletion(dlURL)
                    self.getFilesURL(directory: directory, numberOfFiles: numberOfFiles, prefixOfFile: prefixOfFile, fileNumber: fileNumber + 1, suffixOfFile: suffixOfFile, eashSuccessfulCompletion: eashSuccessfulCompletion, afterAllDone: afterAllDone)
                }
            }
        } else {
            print("Done...")
            afterAllDone()
        }
    }
    
    func populateURLsOfSpeakingDIImages() {
        let numberOfFiles = 78
        var data = [[String: String]]()
        getFilesURL(directory: speakingDIPractices, numberOfFiles: numberOfFiles, prefixOfFile: "DI", suffixOfFile: ".jpg", eashSuccessfulCompletion: { (dlURL) in
            data.append(["ImageURL": dlURL])
        }) {
            self.saveData(path: speakingDIPractices, save: data) { (errMsg) in
                if let err = errMsg {
                    print(err)
                } else {
                    print("Successfully Saved...")
                }
            }
        }
    }
    
    func populateURLsOfSpeakingRLAudios() {
        let numberOfFiles = 76
        var data = [[String: String]]()
        getFilesURL(directory: speakingRLPractices, numberOfFiles: numberOfFiles, prefixOfFile: "RL", suffixOfFile: ".mp3", eashSuccessfulCompletion: { (dlURL) in
            data.append(["AudioTopic": "", "AudioText": "", "AudioURL": dlURL])
        }) {
            self.saveData(path: speakingRLPractices, save: data) { (errMsg) in
                if let err = errMsg {
                    print(err)
                } else {
                    print("Successfully Saved...")
                }
            }
        }
    }
    
    func populateURLsOfSpeakingASQAudios() {
        let numberOfFiles = 137
        var data = [[String: String]]()
        getFilesURL(directory: speakingASQPractices, numberOfFiles: numberOfFiles, prefixOfFile: "ASQ", suffixOfFile: ".mp3", eashSuccessfulCompletion: { (dlURL) in
            data.append(["AudioText": "", "AudioURL": dlURL])
        }) {
            self.saveData(path: speakingASQPractices, save: data) { (errMsg) in
                if let err = errMsg {
                    print(err)
                } else {
                    print("Successfully Saved...")
                }
            }
        }
    }
    
    func populateURLsOfSpeakingRSAudios() {
        let numberOfFiles = 83
        var data = [[String: String]]()
        getFilesURL(directory: speakingRSPractices, numberOfFiles: numberOfFiles, prefixOfFile: "RS", suffixOfFile: ".mp3", eashSuccessfulCompletion: { (dlURL) in
            data.append(["AudioText": "", "AudioURL": dlURL])
        }) {
            self.saveData(path: speakingRSPractices, save: data) { (errMsg) in
                if let err = errMsg {
                    print(err)
                } else {
                    print("Successfully Saved...")
                }
            }
        }
    }
    
    func populateURLsOfListeningFBAudios() {
        let numberOfFiles = 66
        var data = [[String: String]]()
        getFilesURL(directory: listeningFBPractices, numberOfFiles: numberOfFiles, prefixOfFile: "FB", suffixOfFile: ".mp3", eashSuccessfulCompletion: { (dlURL) in
            data.append(["AudioText": "", "Answer": "", "AudioURL": dlURL])
        }) {
            self.saveData(path: listeningFBPractices, save: data) { (errMsg) in
                if let err = errMsg {
                    print(err)
                } else {
                    print("Successfully Saved...")
                }
            }
        }
    }
    
    //-----------------------------------------SPECIFIC---------------------------------------------------------
    private func fetchFileURL(path: String, completion: @escaping (URL?, String?) -> Void) {
        let fileRef = storageRef.child(path)
        fileRef.downloadURL { (url, error) in
            completion(url, error?.localizedDescription)
        }
    }
    
    func fetchSpeakingDIPractices(completion: @escaping (JSON) -> Void) {
        databaseRef.child(speakingDIPractices).observeSingleEvent(of: .value, with: { (snapshot) in
            completion(JSON(snapshot.value as Any))
        }) { (err) in _ = self.handleError(cause: "fetchSpeakingDIPractices", error: err) }
    }
    
    func fetchSpeakingDITipsURL(completion: @escaping (URL?, String?) -> Void) {
        fetchFileURL(path: speakingDITipsPath) { (url, error) in
            completion(url, error)
        }
    }
    
    func fetchSpeakingRLPractices(completion: @escaping (JSON) -> Void) {
        databaseRef.child(speakingRLPractices).observeSingleEvent(of: .value, with: { (snapshot) in
            completion(JSON(snapshot.value as Any))
        }) { (err) in _ = self.handleError(cause: "fetchSpeakingRLPractices", error: err) }
    }
    
    func fetchSpeakingRLTipsURL(completion: @escaping (URL?, String?) -> Void) {
        fetchFileURL(path: speakingRLTipsPath) { (url, error) in
            completion(url, error)
        }
    }
    
    func fetchSpeakingRAPractices(completion: @escaping (JSON) -> Void) {
        databaseRef.child(speakingRAPractices).observeSingleEvent(of: .value, with: { (snapshot) in
            completion(JSON(snapshot.value as Any))
        }) { (err) in _ = self.handleError(cause: "fetchSpeakingRAPractices", error: err) }
    }
    
    func fetchSpeakingRATipsURL(completion: @escaping (URL?, String?) -> Void) {
        fetchFileURL(path: speakingRATipsPath) { (url, error) in
            completion(url, error)
        }
    }
    
    func fetchSpeakingASQPractices(completion: @escaping (JSON) -> Void) {
        databaseRef.child(speakingASQPractices).observeSingleEvent(of: .value, with: { (snapshot) in
            completion(JSON(snapshot.value as Any))
        }) { (err) in _ = self.handleError(cause: "fetchSpeakingASQPractices", error: err) }
    }
    
    func fetchSpeakingASQTipsURL(completion: @escaping (URL?, String?) -> Void) {
        fetchFileURL(path: speakingASQTipsPath) { (url, error) in
            completion(url, error)
        }
    }
    
    func fetchSpeakingRSPractices(completion: @escaping (JSON) -> Void) {
        databaseRef.child(speakingRSPractices).observeSingleEvent(of: .value, with: { (snapshot) in
            completion(JSON(snapshot.value as Any))
        }) { (err) in _ = self.handleError(cause: "fetchSpeakingRSPractices", error: err) }
    }
    
    func fetchSpeakingRSTipsURL(completion: @escaping (URL?, String?) -> Void) {
        fetchFileURL(path: speakingRSTipsPath) { (url, error) in
            completion(url, error)
        }
    }
    
    //---------------------------------------------------------------------------------------------------------
    // MARK: - GENERAL PRIVATE
    //---------------------------------------------------------------------------------------------------------
    //fetch an error data path
    private func fetchErrorDataPath(eid: String) -> String { return "/\(Constants.undefinedErrorsNode)/\(eid)" }
    
    //return customized error message and save uncustomized error info. on the database
    private func handleError(cause: String = "NONE", error: Error?) -> String? {
        func localizedDescription(errCode: Int) -> String? {
            let errorDescription = "\(errCode): " + error!.localizedDescription
            saveErrorMessage(action: cause, msg: errorDescription)
            return errorDescription
        }
        
        if error == nil { return nil } else {
            if let code = (error as NSError?)?.code {
                if let errMsg = errorMsgDictionary[code] { return errMsg } else { return localizedDescription(errCode: code) }
            } else { return localizedDescription(errCode: 99999) }
        }
    }
    
    //save error data
    private func saveErrorMessage(action: String, msg: String) {
        let errorID = FirebaseService.autoID
        let p = fetchErrorDataPath(eid: errorID)
        let value = [action: msg, Constants.time: Date().description]
        saveData(path: p, save: value, completion: nil)
    }

    //save a value on a path with a completion to deal with a save error
    private func saveData(path: String, save value: Any, completion: ((String?) -> Void)?) {
        databaseRef.updateChildValues([path: value]) { (err, ref) in completion?(self.handleError(cause: "saveData", error: err)) }
    }
    
    //save two values on two paths synchronously with a completion to deal with a save error
    private func saveDataSynchronous(pathA: String, valueA: Any, pathB: String, valueB: Any, completion: ((String?) -> Void)?) {
        databaseRef.updateChildValues([pathA: valueA, pathB: valueB]) { (err, ref) in completion?(self.handleError(cause: "saveDataSynchronous", error: err)) }
    }
    
    //save three values on three paths synchronously with a completion to deal with a save error
    private func saveDataSynchronous(pathA: String, valueA: Any, pathB: String, valueB: Any, pathC: String, valueC: Any, completion: ((String?) -> Void)?) {
        databaseRef.updateChildValues([pathA: valueA, pathB: valueB, pathC: valueC]) { (err, ref) in completion?(self.handleError(cause: "saveDataSynchronous", error: err)) }
    }
    
    //delete a data on a path with a completion to deal with a delete error
    private func deleteData(path: String, completion: ((String?) -> Void)?) {
        databaseRef.updateChildValues([path: NSNull()]) { (err, ref) in completion?(self.handleError(cause: "deleteData", error: err)) }
    }
    
    //save a file on a path with a completion to deal with a save error and an url of file
    private func saveFile(path: String, fileData: Data, completion: ((String?, String?) -> Void)?) {
        storageRef.child(path).put(fileData, metadata: nil) { (metadata, err) in
            completion?(self.handleError(cause: "saveFile", error: err), metadata?.downloadURL()?.absoluteString)
        }
    }
    
    //delete a file on a path with a completion to deal with a delete error
    private func deleteFile(path: String, completion: ((String?) -> Void)?) {
        storageRef.child(path).delete { (err) in completion?(self.handleError(cause: "deleteFile", error: err)) }
    }
}
