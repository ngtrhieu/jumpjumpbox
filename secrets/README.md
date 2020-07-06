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

You need to either copy your keystore into ./secrets folder, or generate a new keystore _(recommended)_.

If you use existing keystore, you would need to manually set the following environment variables:

- ANDROID_KEYSTORE_PASS
- ANDROID_KEY_ALIAS_NAME
- ANDROID_KEY_ALIAS_PASS

It is recommended that you generate a new keystore just for development purposes by:

- Run the following command:  
  `keytool -genkey -v -keystore keystore.keystore -alias user -keyalg RSA -keysize 2048 -validity 10000`
- When prompted for keystore password, put `password`.
- Press enter to skip through the rest of the prompts.
- Copy the newly generated `keystore.keystore` file to the `./secrets` folder.

### firebase.token

- On your development machine, run `yarn firebase login:ci` to start the login process with firebase.
- Follow the instruction on terminal to acquire the login token.
- Copy the login token into the `firebase.token` file.
