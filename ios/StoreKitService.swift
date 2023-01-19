//
//  StoreKitService.swift
//  SuperwallUIKitExample
//
//  Created by Yusuf Tör on 05/04/2022.
//

import StoreKit
import Combine

final class StoreKitService: NSObject, ObservableObject {
  static let shared = StoreKitService()
  var isSubscribed = CurrentValueSubject<Bool, Never>(false)
  enum StoreError: Error {
    case failedVerification
  }
  private var restoreCompletion: ((Bool) -> Void)?

  override init() {
    super.init()
    SKPaymentQueue.default().add(self)
  }

  func purchase(_ product: SKProduct) async throws {
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }

  func restorePurchases() async -> Bool {
    let result = await withCheckedContinuation { continuation in
      // Using restoreCompletedTransactions instead of just refreshing
      // the receipt so that RC can pick up on the restored products,
      // if observing. It will also refresh the receipt on device.
      restoreCompletion = { completed in
        return continuation.resume(returning: completed)
      }
      SKPaymentQueue.default().restoreCompletedTransactions()
    }
    restoreCompletion = nil
    await loadSubscriptionState()
    return result
  }

  func loadSubscriptionState() async {
    for await result in Transaction.currentEntitlements {
      guard case .verified(let transaction) = result else {
        continue
      }
      if transaction.revocationDate == nil {
        isSubscribed.send(true)
        return
      }
    }
    isSubscribed.send(false)
  }
}

// MARK: - SKPaymentTransactionObserver
extension StoreKitService: SKPaymentTransactionObserver {
  func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    restoreCompletion?(true)
  }

  func paymentQueue(
    _ queue: SKPaymentQueue,
    restoreCompletedTransactionsFailedWithError error: Error
  ) {
    restoreCompletion?(false)
  }

  func paymentQueue(
    _ queue: SKPaymentQueue,
    updatedTransactions transactions: [SKPaymentTransaction]
  ) {
    for transaction in transactions {
      switch transaction.transactionState {
      case .purchased:
        isSubscribed.send(true)
        SKPaymentQueue.default().finishTransaction(transaction)
      case .failed,
        .restored:
        SKPaymentQueue.default().finishTransaction(transaction)
      default:
        break
      }
    }
  }
}
