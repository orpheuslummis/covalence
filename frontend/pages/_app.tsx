import "../styles/global.css";
import { AppProps } from "next/app";
import "@rainbow-me/rainbowkit/styles.css";
import {
  getDefaultWallets,
  RainbowKitProvider,
  darkTheme,
} from "@rainbow-me/rainbowkit";
import { configureChains, createConfig, sepolia, WagmiConfig } from "wagmi";
import { goerli, mainnet, filecoin } from "wagmi/chains";
import { publicProvider } from "wagmi/providers/public";
import { useState, useEffect } from "react";
import { getContractData } from "../utils/Contracts";

const { chains, publicClient, webSocketPublicClient } = configureChains(
  [
    goerli,
    sepolia,
    filecoin,
    ...(process.env.NEXT_PUBLIC_ENABLE_TESTNETS === "true" ? [goerli] : []),
  ],
  [publicProvider()]
);
const projectId = "225eec31c0bf2e9d1b0cc6b8e49faa16";

const { connectors } = getDefaultWallets({
  appName: "Covalence",
  projectId: projectId || "",
  chains,
});

const wagmiConfig = createConfig({
  autoConnect: true,
  connectors,
  publicClient,
  webSocketPublicClient,
});

export default function Covalence({ Component, pageProps }: AppProps) {
  const [contractAddress, setContractAddress] = useState<`0x${string}`>("0x");
  const [contractABI, setContractABI] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchContractData = async () => {
      const { contractAddress, contractABI } = await getContractData();
      setContractAddress(contractAddress);
      setContractABI(contractABI);
      setIsLoading(false);
    };
    fetchContractData();
  }, []);

  if (isLoading) {
    return <div>Loading...</div>; // Or any loading spinner component
  }

  return (
    <WagmiConfig config={wagmiConfig}>
      <RainbowKitProvider
        coolMode
        chains={chains}
        modalSize="compact"
        theme={darkTheme()}
      >
        <Component
          {...pageProps}
          contractAddress={contractAddress}
          contractABI={contractABI}
        />
      </RainbowKitProvider>
    </WagmiConfig>
  );
}
