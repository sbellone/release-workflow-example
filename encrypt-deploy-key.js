// https://docs.github.com/en/rest/guides/encrypting-secrets-for-the-rest-api
const sodium = require('libsodium-wrappers');
const fs = require('fs');

const publicKey = process.argv[2];
const privateKeyFile = process.argv[3];

const privateKey = fs.readFileSync(privateKeyFile).toString();

// Check if libsodium is ready and then proceed.
sodium.ready.then(() => {
  // Convert the secret and key to a Uint8Array.
  const binkey = sodium.from_base64(publicKey, sodium.base64_variants.ORIGINAL);
  const binsec = sodium.from_string(privateKey);

  // Encrypt the secret using libsodium
  const encBytes = sodium.crypto_box_seal(binsec, binkey);

  // Convert the encrypted Uint8Array to Base64
  const output = sodium.to_base64(encBytes, sodium.base64_variants.ORIGINAL);

  // Print the output
  console.log(output);
});
