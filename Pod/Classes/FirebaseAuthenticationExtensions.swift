//
//  File.swift
//  Pods
//
//  Created by Maximilian Alexander on 7/26/15.
//
//
import Foundation
import RxSwift
import Firebase

public extension Firebase {
    
    
    /// Observing FAuthData. This will only send a value if the user is logged in. If the user is not authenticated in it will not send anything
    ///
    func rx_firebaseObserveAuth() -> Observable<FAuthData> {
        return create { (observer: ObserverOf<FAuthData>) -> Disposable in
            
            let handle = self.observeAuthEventWithBlock({ (authData: FAuthData!) -> Void in
                if authData != nil
                {
                    sendNext(observer, authData)
                }
            })
            
            return AnonymousDisposable{
                self.removeObserverWithHandle(handle)
            }
            
        }
    }
    
    func rx_firebaseAuthUser(email: String, password: String) -> Observable<FAuthData> {
        return create({ (observer : ObserverOf<FAuthData>) -> Disposable in
            
            self.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
                if error != nil {
                    sendError(observer, error)
                }else{
                    sendNext(observer, authData)
                    sendCompleted(observer)
                }
            })
            
            return AnonymousDisposable{}
        })
    }
    
    func rx_firebaseAuthAnonymousUser() -> Observable<FAuthData> {
        return create({ (observer : ObserverOf<FAuthData>) -> Disposable in
            
            self.authAnonymouslyWithCompletionBlock({ (error, authData) -> Void in
                if error != nil{
                    sendError(observer, error)
                }else{
                    sendNext(observer, authData)
                    
                }
            })
            return AnonymousDisposable{}
        })
    }
    
    func rx_firebaseAuthWithCustomToken(authToken : String) -> Observable<FAuthData> {
        return create({ (observer: ObserverOf<FAuthData>) -> Disposable in
            
            self.authWithCustomToken(authToken, withCompletionBlock: { (error, authData) -> Void in
                if(error != nil){
                    sendError(observer, error)
                }else{
                    sendNext(observer, authData)
                    sendCompleted(observer)
                }
            })
            
            return AnonymousDisposable{}
        })
    }
    
    
    
    
}