//
//  Realm.swift
//  Blindcast
//
//  Created by Jan Anstipp on 14.12.19.
//  Copyright © 2019 handycap. All rights reserved.
//

import Foundation
import RealmSwift
import os.log

class RealmDatabase{
    
    static func fetchStoredObjects<T: Object>(obecjts: [T]) -> [T]{
        var result: [T] = []
        let realm: Realm
        
        do {
            realm = try Realm()
        }catch let error{
            os_log("<Fail connect Realm> %s", log: Logs.realmDatabase, type: .fault, "\(error.localizedDescription)")
            return result
        }
        
        do{
            try realm.write {
                let list = realm.objects(T.self)
                for y in list{
                    result.append(y)
                }
            }
        } catch let error{
            os_log("<Fail fetch stored %s> %s", log: Logs.realmDatabase, type: .fault, "\(T.self)", error.localizedDescription)
        }
        os_log("<Success fetch stored %s>", log: Logs.realmDatabase, type: .debug, "\(T.self)")
        return result
    }
    
    static func savaRealmObjects<T: Object>(objects: [T]){
        let realm: Realm
        do {
            realm = try Realm()
        }catch let error{
            os_log("<Fail connect Realm> %s", log: Logs.realmDatabase, type: .fault, "\(error.localizedDescription)")
            return
        }
        
        do {
            try realm.write {
                realm.add(objects)
            }
        }catch let error{
            os_log("<Fail save %s> %s", log: Logs.realmDatabase, type: .error, "\(T.self)" ,"\(error.localizedDescription)")
            
        }
        os_log("<Succes save %s>", log: Logs.realmDatabase, type: .debug,"\(T.self)")
    }
    
//    func deleteType<T: Object>(type: T){ //where T: Object{
//        let realm = try! Realm()
//        let deletesObjects = realm.objects(type.self)
//
//        try! realm.write {
//            realm.delete(deletesObjects)
//        }
//    }
    
    func deleteAllData(){
        let realm: Realm
        do {
            realm = try Realm()
        }catch let error{
            os_log("<Fail connect Realm> %  ", log: Logs.realmDatabase, type: .fault, "\(error.localizedDescription)")
            return
        }
        
        do{
            try realm.write {
                realm.deleteAll()
                os_log("<Succes Delete All Data>", log: Logs.realmDatabase, type: .debug)
            }
        }catch let error{
            os_log("<Fail Delete All Data> %s", log: Logs.realmDatabase, type: .debug, "\(error.localizedDescription)")
        }
    }
    
    
    /**
     Nicht so praktisch bzw wenn sollte man kompletes device  path löschen und neu bulden, da der default server nicht neu initialisiert wird.
     */
//    private func deleteDataBase(){
//        do{
//            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
//            os_log("<Success Delete Database>", log: Logs.realmDatabase, type: .debug)
//        }catch let error{
//            os_log("<Fail Delete Database> %s", log: Logs.realmDatabase, type: .debug, "\(error.localizedDescription)")
//        }
//    }
    
    static func getPath() -> (device:String,apllication:String,url:URL)?{
        let url = Realm.Configuration.defaultConfiguration.fileURL
        var device: String = ""
        var application: String = ""
        if let pathCompontens = url?.pathComponents {
            for index in pathCompontens.indices{
                if (pathCompontens[index].elementsEqual("Devices")){
                    device = pathCompontens[index + 1]
                }else if (pathCompontens[index].elementsEqual("Application")){
                    application = pathCompontens[index + 1]
                }
            }
            print(device)
            print(application)
            print(url!)
            return (device,application,url!)
        }
        return nil
    }
    
//    func refreashRealmMigration(){
//        let config = Realm.Configuration(
//            schemaVersion: 1,
//            migrationBlock: { migration, oldSchemaVersion in
//                if (oldSchemaVersion < 1) {
//
//
//                }
//        })
//        Realm.Configuration.defaultConfiguration = config
//        do {
//            let realm = try Realm()
//            if realm.isEmpty{
//
//            }
//            os_log("<Success refreashRealmMigration>", log: Logs.realmDatabase, type: .debug)
//        }catch let error{
//            os_log("<Fail refreashRealmMigration> %s", log: Logs.realmDatabase, type: .debug, "\(error.localizedDescription)")
//        }
//
//
//    }
}
