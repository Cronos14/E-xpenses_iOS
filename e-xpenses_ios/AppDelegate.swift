//
//  AppDelegate.swift
//  e-xpenses_ios
//
//  Created by raul tadeo gonzale alvarez on 29/04/16.
//  Copyright © 2016 masnegocio. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NSXMLParserDelegate{

    var window: UIWindow?
    
    
    var nodos = [NodoXml]()


   
    func applicationWillResignActive(application: UIApplication) {
        print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(application: UIApplication) {
       print("applicationWillEnterForeground")
    }

    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("didReceiveRemoteNotification")
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("didReceiveLocalNotification")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        print("applicationWillTerminate")
        self.saveContext()
    }
    
    

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.masnegocio.e_xpenses_ios" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("e_xpenses_ios", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    //Mark: -XMLParser
    
    func saveNodos(file:NSURL){
        let xmlParse = NSXMLParser(contentsOfURL: file)
        xmlParse?.delegate = self
        xmlParse?.parse()
    }
    
   
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("startElement \(elementName)")
        
        
        for(atributo,valor) in attributeDict{
            print("\(atributo):\(valor)")
        }
        
        nodos.append(NodoXml(nombre:elementName,atributos: attributeDict))
        
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        print("foundCharacters \(string)")
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("endElement \(elementName)")
        
    }
    
    //MARK: -AirDrop
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        
        
        //let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file as! String)
        let facturaCompleta = try? NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
        
        saveNodos(url)
        
        
        //cambiar de UIViewController
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewControlleripad : FacturaViewController = mainStoryboardIpad.instantiateViewControllerWithIdentifier("factura") as! FacturaViewController
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        initialViewControlleripad.nodos = nodos
        initialViewControlleripad.facturaCompleta = facturaCompleta as! String
        self.window?.rootViewController = initialViewControlleripad
        self.window?.makeKeyAndVisible()
        
        //cambiar a pushViewController
        //let rootViewController = self.window!.rootViewController as! UINavigationController
        //rootViewController.pushViewController(initialViewControlleripad, animated: true)
        
        


        return true

    }
    
   
    
}

