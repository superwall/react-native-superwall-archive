import React, { useEffect, useState } from 'react';
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

const superwallApiKey: string = '<YOUR_SUPERWALL_API_KEY>';
const revenueCatApiKey: string | null = null; //Optional

export default function App() {
  const [enableTrigger, setEnableTrigger] = useState(false);
  useEffect(() => {
    if (superwallApiKey != '<YOUR_SUPERWALL_API_KEY>') {
      setEnableTrigger(true);
    }
    initPaywall(superwallApiKey, revenueCatApiKey);
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
      {!enableTrigger && (
        <Text style={{ color: 'red' }}>
          You need to set your superwallApiKey
        </Text>
      )}
      <Text>Superwall Example</Text>
      <Button
        onPress={showPaywall}
        title={'Show Paywall'}
        disabled={!enableTrigger}
      />
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
