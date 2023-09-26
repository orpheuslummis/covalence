import { ethers } from 'ethers';

export function stringToBytes(ipfsCidString: string): any {
  
  const bytes = ethers.utils.toUtf8Bytes(ipfsCidString);
  const paddedBytes = new Uint8Array(32);
  paddedBytes.fill(0);
  bytes.forEach((byte, index) => {
    paddedBytes[index] = byte;
  });
  return paddedBytes;


}

export function bytesToString(bytes32: Uint8Array): any {
  const bytes = new Uint8Array(bytes32);
  while (bytes[0] === 0) {
    bytes.shift();
  }
  const string = ethers.utils.toUtf8String(bytes);
  return string;
  


}

