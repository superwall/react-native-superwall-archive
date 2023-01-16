import * as React from 'react';
import {
  StyleSheet,
  View,
  Text,
  Button,
  NativeModules,
  NativeEventEmitter,
} from 'react-native';
import { initPaywall, trigger } from 'react-native-superwall';
const eventEmitter = new NativeEventEmitter(NativeModules.Superwall);

const apiKey: string = '<YOUR_API_KEY>';
const revenueCatKey: string | null = null; //Optional

export default function App() {
  React.useEffect(() => {
    initPaywall(apiKey, revenueCatKey);
    eventEmitter.addListener('superwallAnalyticsEvent', (res) => {
      console.log(
        'superwall event',
        res?.event,
        JSON.stringify(res?.params, null, 4)
      );
    });
  }, []);

  const showPaywall = async () => {
    try {
      const res = await trigger('campaign_trigger');
      //Respond to purchase
      console.log(JSON.stringify(res, null, 4), 'results from paywall');
    } catch (e) {
      console.error(e);
    }
  };

  return (
    <View style={styles.container}>
      <Text>Superwall Example</Text>
      <Button onPress={showPaywall} title={'Show Paywall'} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
