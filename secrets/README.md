# Preparing secrets for development build

> :warning: **This folder is to store build secrets**. DO NOT COMMIT files in this folder into git.

## What do you need to setup

You should have these files inside your `secrets` folder:

- `Unity_lic.ulf`  
  (optional)  
  Unity license file, used to activate Unity.

- `keystore.keystore`  
  Android keystore file, used to sign Android build.

- `firebase.token`  
  Firebase CLI token, used to update build to Firebase app distribution.

Continue reading to learn how to setup these files.

## Detailed guides:

### Unity_lic.ulf

This file contains the information necessary to activate Unity to use YOUR license (applicable for Plus/Pro users). Skip this file if your docker's Unity to use the default license instead.

To get your Unity license file, do the following:

- Pull `ngtrhieu/unity3d` docker image.

```bash
docker pull ngtrhieu/unity3d
```

- Run bash inside the docker image, like this :

```bash
docker run -it --rm ngtrhieu:unity3d bash
```

- Once inside the docker container's bash, try to activate Unity by running

```bash
xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' \
/opt/Unity/Editor/Unity \
-logFile /dev/stdout \
-batchmode \
-username "{UNITY_USERNAME}" -password "{UNITY_PASSWORD}" -serial "{UNITY_SERIAL}"
```

- Once the command finished without any errors, obtain the content of the license by running:

```bash
cat /root/.local/share/unity3d/Unity/Unity_lic.ulf
```

- Copy the content of the file into `Unity_lic.ulf` file and place it inside `./secrets` folder.

- Use your favorite editor _(i.e: vscode)_, convert the line ending to use LF _(i.e: linux styled)_.

### keystore.keystore

You need to either copy your keystore into ./secrets folder, or generate a new keystore _(recommended)_.

If you use existing keystore, you would need to manually set the following environment variables:

- ANDROID_KEYSTORE_PASS
- ANDROID_KEY_ALIAS_NAME
- ANDROID_KEY_ALIAS_PASS

It is recommended that you generate a new keystore just for development purposes by:

- Run the following command:

```bash
keytool -genkey -v -keystore keystore.keystore -alias user -keyalg RSA -keysize 2048 -validity 10000
```

- When prompted for keystore password, put `password`.
- Press enter to skip through the rest of the prompts.
- Copy the newly generated `keystore.keystore` file to the `./secrets` folder.

### firebase.token

- On your development machine, to start the login process with firebase, run

```bash
yarn firebase login:ci
```

- Follow the instruction on terminal to acquire the login token.
- Copy the login token into the `firebase.token` file.
