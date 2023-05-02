import Foundation
import Paywall

@objc(Superwall)
class Superwall: RCTEventEmitter {
    
    public static var emitter: RCTEventEmitter!

      override init() {
        super.init()
        Superwall.emitter = self
      }

      open override func supportedEvents() -> [String] {
        ["superwallAnalyticsEvent"]
      }
    
    
    @objc(initPaywall:useRevenueCat:)
    func initPaywall(superwallApiKey:String, useRevenueCat:Bool) -> Void {
        PaywallService.initPaywall(superwallApiKey: superwallApiKey, useRC: useRevenueCat)
    }
    
    
    @objc(trigger:resolver:rejecter:)
    func trigger(campaignName:String, resolver: @escaping RCTPromiseResolveBlock,  rejecter: @escaping RCTPromiseRejectBlock) -> Void {
        Paywall.trigger(
          event: campaignName,
          params: nil,
          onSkip: { error in
            rejecter("error", error?.description, nil)
          },
          onPresent: nil,
          onDismiss: { didPurchase, productId, paywallInfo in
              if didPurchase {
                  resolver(["didPurchase": true, "productId": productId])
              } else {
                resolver(["didPurchase": false, "productId": nil])
              }
            }
        )
    }

    
}
