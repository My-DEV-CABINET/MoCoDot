fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios certs

```sh
[bundle exec] fastlane ios certs
```

Match Certs

### ios set_keychain

```sh
[bundle exec] fastlane ios set_keychain
```

Set_keychain

### ios run_unit_tests

```sh
[bundle exec] fastlane ios run_unit_tests
```

Run all the tests

### ios build

```sh
[bundle exec] fastlane ios build
```

Build the app

### ios pilot_to_testflight

```sh
[bundle exec] fastlane ios pilot_to_testflight
```

Upload to TestFlight

### ios push_to_git_remote

```sh
[bundle exec] fastlane ios push_to_git_remote
```

git push with dynamic local and remote branch names

### ios app_store_upload

```sh
[bundle exec] fastlane ios app_store_upload
```

App Store Upload

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
