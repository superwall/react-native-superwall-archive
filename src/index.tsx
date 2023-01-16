import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-superwall' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const Superwall = NativeModules.Superwall
  ? NativeModules.Superwall
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function initPaywall(apiKey: string, revenueCatKey: string | null) {
  return Superwall.initPaywall(apiKey, revenueCatKey);
}

export function trigger(campaignName: string) {
  return Superwall.trigger(campaignName);
}

export function test(campaignName: string) {
  return Superwall.testTrigger(campaignName);
}
