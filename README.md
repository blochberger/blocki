#  Blocki

<img src="screenshot.png" alt="Screenshot of Blocki" width="556" heigth="280"/>

A lot of websites out there have many minor annoyances. If you visit those websites frequently, it drastically can reduce your browsing experience. With Blocki, you get control back and can manually specify rules of which content you want to block or hide.

Most content blockers for Safari only offer fixed filter lists that are bundled with the application and lack any configuration. Blocki's aim is to grant you full control over the content-blocking rules. Blocki does not block any content by default.

For now, you can only edit rule set by modifying the `blockerList.json` file, as described in [Creating a content blocker](https://developer.apple.com/documentation/safariservices/creating_a_content_blocker).

Recommendation: Use Blocki in combination with other content blockers, such as [Ka-Block!](https://github.com/dgraham/Ka-Block) or [Hush](https://github.com/oblador/hush).

## Known Issues

- Reloading rules in Safari does not work correctly, e. g., if the rule list is malformed.

  **Affects**

  macOS 12.5.1

  **Details**

  Inspecting the system log with the Console application or the following command:

  ```sh
  log show --predicate 'process == "Safari" AND subsystem == "com.apple.Safari"' --last 10m
  ```

  reveals the following error:

  ```
  Error loading content blocker io.github.blochberger.Blocki.Extension: Error Domain=WKErrorDomain Code=6 "(null)"
  ```

  The error code `6` is [`WKErrorContentRuleListStoreCompileFailed`](https://developer.apple.com/documentation/webkit/wkerrorcode/wkerrorcontentruleliststorecompilefailed). However, the error received in the completion handler of [`SFContentBlockerManager.reloadContentBlocker(withIdentifier:completionHandler:)`](https://developer.apple.com/documentation/safariservices/sfcontentblockermanager/1620151-reloadcontentblocker) is `nil`. Presumably due to a bug in recent versions of macOS (reported to Apple as FB11484001).
