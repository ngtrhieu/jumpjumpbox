# Preparing secrets for development build

> :warning: **This folder is to store build secrets**. DO NOT COMMIT files in this folder into git.

## What do you need to setup

You should have these files inside your `secrets` folder:

- `Unity_lic.ulf`  
  (optional)  
  Unity license file, used to activate Unity.

- `keystore.keystore`  
  Android keystore file, used to sign Android build.

- `credentials.sh`  
  The credentials are stored in this file.

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

Unity needs this keystore to sign your Android build. You need to either copy your keystore into ./secrets folder, or generate a new keystore _(recommended)_.

To generate your own keystore, just for development purposes by:

- Run the following command:

```bash
keytool -genkey -v -keystore keystore.keystore -alias <GOOGLE_KEY_ALIAS_NAME> -keyalg RSA -keysize 2048 -validity 10000
```

- When prompted for keystore password, put `password`.
- Press enter to skip through the rest of the prompts.
- Copy the newly generated `keystore.keystore` file to the `./secrets` folder.

Regardless of whether you use your own keystore, or generate new one, you need to set these environment variables, preferably into `.secrets/credentials.sh`:

```bash
export GOOGLE_KEYSTORE_PASS=${GOOGLE_KEYSTORE_PASS:-"your-keystore-password"}
export GOOGLE_KEY_ALIAS_NAME=${GOOGLE_KEY_ALIAS_NAME:-"your-key-alias"}
export GOOGLE_KEY_ALIAS_PASS=${GOOGLE_KEY_ALIAS_PASS:-"your-key-password"}
```

### credentials.sh

`credentials.sh` is the bash file that set the rest of the passwords into environment variables. The required variables are:

```bash
#!/usr/bin/env bash

# AWS credentials
export AWS_REGION=${AWS_REGION:-'valid-aws-region'}
export AWS_ACCESS_KEY=${AWS_ACCESS_KEY:-'your-access-key'}
export AWS_ACCESS_SECRET=${AWS_ACCESS_SECRET:-'your-access-password'}

# Google keystore passwords
export GOOGLE_KEYSTORE_PASS=${GOOGLE_KEYSTORE_PASS:-"your-keystore-password"}
export GOOGLE_KEY_ALIAS_NAME=${GOOGLE_KEY_ALIAS_NAME:-"your-key-alias"}
export GOOGLE_KEY_ALIAS_PASS=${GOOGLE_KEY_ALIAS_PASS:-"your-key-password"}

# Apple provisioning profile
export APPLE_USERNAME=${APPLE_USERNAME:-'your-apple-developer-id/email'}
export APPLE_TEAM_ID=${APPLE_TEAM_ID:-'your-apple-developer-team-id'}
export APPLE_PROVISION_PROFILE=${APPLE_PROVISION_PROFILE:-"your-provisioning-profile-used"}
export APPLE_PROVISION_PROFILE_PASSWORD=${APPLE_PROVISION_PROFILE_PASSWORD:-'your-profile-encryption-passphrase'}
export APPLE_PROVISION_PROFILE_BUCKET=${APPLE_PROVISION_PROFILE_BUCKET:-'the-s3-bucket-storing-encrypted-profile'}
export APPLE_CODE_SIGN_IDENTITY=${APPLE_CODE_SIGN_IDENTITY:-'code-sign-identity'}

# Firebase CLI token
# Used to upload builds to app distribution
export FIREBASE_CLI_TOKEN=${FIREBASE_CLI_TOKEN:-'your-firebase-cli-login-token'}


```

- AWS_ACCESS keypairs are used to both download provisioning profiles (via [fastlane match](https://docs.fastlane.tools/actions/match/)) and upload build artifacts between build stages. Make sure it has S3 read/write permissions to the target buckets.

- MATCH_PASSWORD is the passphrase used to encrypt iOS provisioning profile via [fastlane match](https://docs.fastlane.tools/actions/match/).

- FIREBASE_CLI_TOKEN is the token to upload your builds to Firebase AppDistribution via Firebase CLI. Run `yarn firebase login:ci` and go through the login step to acquire the token.
