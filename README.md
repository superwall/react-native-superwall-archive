# react-native-superwall

React-Native module for Superwall

See the example folder for a demo or to test your paywalls

This only works on iOS
Superwall: https://superwall.com/
RevenueCat: https://www.revenuecat.com/

## Running the example
Open example/App.tsx
Update the apiKey var with your Superwall key
Optional, update the revenueCatKey var with your RevenueCat key

```sh
yarn
yarn example ios
```

## Installation

```sh
npm install react-native-superwall
```

## Usage

```js
import { initPaywall, trigger } from 'react-native-superwall';

//Even emitter for analyitics events
const eventEmitter = new NativeEventEmitter(NativeModules.Superwall);

//Initailize Superwall
initPaywall(<YOUR_API_KEY>, <OPTIONAL_REVENUECAT_KEY);
//Trigger paywall
const res = await trigger(<Campaign_Name>);


//Listen for analyitics events
eventEmitter.addListener('superwallAnalyticsEvent', (res) => {
  console.log('Superwall event', res?.event, JSON.stringify(res, null, 4));
});
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

## TODO
* [ ] Add event trigger params to superwall, currently nil
* [ ] Clean up swift code

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
