# react-native-superwall

React-Native module for Superwall

See the example folder for a demo or to test your paywalls

NOTE: Currently only supports iOS\
Superwall: https://superwall.com/ \
RevenueCat: https://www.revenuecat.com/

## Running the example
Open example/App.tsx\
Update the superwallApiKey var with your Superwall api key\
Optional, update the revenueCatApiKey var with your RevenueCat key\

```sh
yarn
yarn example ios
```

## Installation
NOTE: Not published to npm.

```sh
npm install react-native-superwall
```

## Usage

### Import
```js
import { initPaywall, trigger } from 'react-native-superwall';

import {
  NativeModules,
  NativeEventEmitter,
} from 'react-native';
```

### Event emitter. Listen for Superwall events
```js
const eventEmitter = new NativeEventEmitter(NativeModules.Superwall);
```

### Initailize Superwall
```js
initPaywall(<YOUR_SUPERWALL_API_KEY>, <OPTIONAL_REVENUECAT_KEY);
```

### Trigger paywall
```js
const res = await trigger(<Campaign_Name>);
```

### Listen for analyitics events
```js
eventEmitter.addListener('superwallAnalyticsEvent', (res) => {
  console.log('Superwall event', res?.event, JSON.stringify(res, null, 4));
});
```

List of Superwall tracked events: https://github.com/superwall-me/paywall-ios/blob/ed7eb99b839c8eb33479af92b490f2ddcd0d5053/Sources/Paywall/Documentation.docc/AutomaticallyTrackedEvents.md

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

## TODO
* [ ] Add event trigger params to superwall, currently nil
* [ ] Clean up swift code
* [ ] Publish NMP package

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
