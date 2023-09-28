import { ethers } from 'ethers';
import axios from 'axios';
import {abi_fallback} from './abi_fallback';

let cachedContractData: any | null = null;

export const getContractData = async () => {
  if (cachedContractData) {
    return cachedContractData;
  }

  const contractAddress = process.env.NEXT_PUBLIC_COVALENCE_CONTRACT;

  if (!contractAddress) {
    throw new Error(
      "The COVALENCE_CONTRACT environment variable is not defined",
    );
  }

  if (!ethers.utils.isAddress(contractAddress)) {
    throw new Error(
      "The COVALENCE_CONTRACT environment variable is not a valid Ethereum address",
    );
  }

  if (!contractAddress.startsWith('0x')) {
    throw new Error(
      "The contract address must start with '0x'",
    );
  }

  let response;
  let contractABI;
  try {
    let url = `https://api-sepolia.etherscan.io/api?module=contract&action=getabi&address=${contractAddress}`;
    response = await axios.get(url);
    contractABI = JSON.parse(response.data.result);
    // console.log("Contract ABI parsed from Etherscan", contractABI);
  } catch (error) {
    console.log("Error parsing the contract ABI from Etherscan, using fallback ABI");
    contractABI = JSON.parse(abi_fallback);
  }

  const contractData = {
    contractAddress: contractAddress as `0x${string}`,
    contractABI,
  };

  cachedContractData = contractData;

  return contractData;
};

