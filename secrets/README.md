# Preparing secrets for development build

This folder is to store build secrets. DO NOT COMMIT files in this folder into git.

## What do you need to setup

You should have these files inside your `secrets` folder:

- `Unity_lic.ulf`  
  Unity license file, used to activate Unity.

- `keystore.keystore`  
  Android keystore file, used to sign Android build.

- `firebase.token`  
  Firebase CLI token, used to update build to Firebase app distribution.

Continue reading to learn how to setup these files.

## Detailed guides:

### Unity_lic.ulf

_tbw_

### keystore.keystore

_tbw_

### firebase.token

- On your development machine, run `yarn firebase login:ci` to start the login process with firebase.
- Follow the instruction on terminal to acquire the login token.
- Copy the login token into the `firebase.token` file.


