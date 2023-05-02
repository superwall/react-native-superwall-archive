//
//  PaywallService.swift
//  Superwall
//
//  Created by Steve McIntyre on 12/30/22.
//

import Foundation
import Paywall
import StoreKit
import RevenueCat

public var useRevenueCat = false;
public var isActive = false;

final class PaywallService {
    static var shared = PaywallService()
    static func initPaywall(superwallApiKey:String, useRC:Bool) {
        if useRC {
            useRevenueCat = true;
        }
        
        let options = PaywallOptions()
        // Uncomment to show debug logs
        //options.logging.level = .debug
        if(useRevenueCat){
            // we shouldn't configure RC, and we shouldnt be setting appUserId to null
            //Purchases.logLevel = .debug
            // Purchases.configure(
            //     with: Configuration.Builder(withAPIKey: revenueCatApiKey)
            //         .with(appUserID: nil)
            //         .build()
            // )
            
            Purchases.shared.getCustomerInfo { (customerInfo, error) in
                if customerInfo?.entitlements.active.isEmpty == false {
                    isActive = true;
                } else {
                    isActive = false;
                }
            }
        }
        
        Paywall.configure(
            apiKey: superwallApiKey,
            delegate: shared,
            options: options
        )
    }
}

// MARK: - Paywall Delegate
extension PaywallService: PaywallDelegate {
    //1
    func purchase(product: SKProduct)  {
        if (useRevenueCat) {
            Purchases.shared.purchase(product: StoreProduct(sk1Product: product)) {
                (transaction, customerInfo, error, userCancelled) in
                if customerInfo?.entitlements.active.isEmpty == false {
                    isActive = true;
                } else {
                    isActive = false;
                }
            }
        } else {
            Task {
                  try? await StoreKitService.shared.purchase(product)
                }
        }
    }
    
    // 2
    func restorePurchases(completion: @escaping (Bool) -> Void) {
        if (useRevenueCat) {
            Task {
                do {
                    let purchaserInfo = try await Purchases.shared.restorePurchases()
                    if purchaserInfo.entitlements.active.isEmpty == false {
                        completion(true);
                    } else {
                        completion(false);
                    }
                } catch {
                    completion(false)
                }
            }
        } else {
            Task {
                let result = try await StoreKitService.shared.restorePurchases()
                completion(result)
            }
        }
    }
    
    // 3
    func isUserSubscribed() -> Bool {
        if (useRevenueCat) {
            return isActive
        } else {
            return StoreKitService.shared.isSubscribed.value
        }
    }
    
    func trackAnalyticsEvent(
        withName name: String,
        params: [String: Any]
    ) {
        Superwall.emitter.sendEvent(withName: "superwallAnalyticsEvent", body: ["event": name, "params":params])
    }
}

