# What is RudderStack?

[RudderStack](https://rudderstack.com/) is a **customer data pipeline** tool for collecting, routing and processing data from your websites, apps, cloud tools, and data warehouse.

More information on RudderStack can be found [here](https://github.com/rudderlabs/rudder-server).

## Integrating CleverTap with RudderStack's iOS SDK

[CleverTap](https://clevertap.com/) s a popular customer engagement and retention platform. Its in-app analytics and marketing capabilities allow you to get real-time insights into your customers and build valuable, long-term relationships with them. With CleverTap, you can easily your users' actions and understand how they are using your product. You can also segment users based on their behavior and run targeted campaigns to boost your user engagement and retention metrics.

1. Add CleverTap as destination from Rudder Dashboard and add the app secret key.

2. Rudder-CleverTap is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Rudder-CleverTap'
```

## Initialize ```RudderClient```

Put this code in your ```AppDelegate.m``` file under the method ```didFinishLaunchingWithOptions```
```xcode
RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
[builder withDataPlaneUrl:<YOUR_DATA_PLANE_URL>];
[builder withFactory:[RudderCleverTapFactory instance]];
[RSClient getInstance:<YOUR_WRITE_KEY> config:[builder build]];
```

## Send Events

Follow the steps from the [RudderStack iOS SDK](https://github.com/rudderlabs/rudder-sdk-ios).

## Contact Us

If you come across any issues while configuring or using this integration, please feel free to start a conversation on our [Slack](https://resources.rudderstack.com/join-rudderstack-slack) channel. We will be happy to help you.
