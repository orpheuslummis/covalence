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
  return
}

