## 1.1.5
* Downgraded the `google_mobile_ads`

## 1.1.4

* **Exponential Backoff for Ad Load Retry**: Implemented exponential backoff mechanism for retrying failed app open ad loads, improving ad availability in unstable network conditions.
* **Preload AppOpenAd After Dismissal**: Enhanced ad lifecycle by preloading a new app open ad immediately after one is dismissed, ensuring ads are ready for future app launches.
* **Improved Error Handling & Logging**: Added more detailed error logs and failure recovery, enabling better insight into ad load issues and smoother ad presentation flow.
