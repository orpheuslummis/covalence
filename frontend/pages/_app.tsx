import "../styles/global.css";
import { AppProps } from "next/app";
import "@rainbow-me/rainbowkit/styles.css";
import {
  getDefaultWallets,
  RainbowKitProvider,
  darkTheme,
} from "@rainbow-me/rainbowkit";
import { configureChains, createConfig, sepolia, WagmiConfig } from "wagmi";
import {
  goerli,
  mainnet,
  optimism,
  polygon,
  base,
  zora,
  filecoin,
  filecoinHyperspace,
  filecoinCalibration,
} from "wagmi/chains";
import { publicProvider } from "wagmi/providers/public";

const { chains, publicClient, webSocketPublicClient } = configureChains(
  [
    goerli,
    sepolia,
    filecoin,
    filecoinHyperspace,
    filecoinCalibration,

    ...(process.env.NEXT_PUBLIC_ENABLE_TESTNETS === "true" ? [goerli] : []),
  ],
  [publicProvider()],
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

export default function MyApp({ Component, pageProps }: AppProps) {
  return (
    <WagmiConfig config={wagmiConfig}>
      <RainbowKitProvider
        coolMode
        chains={chains}
        modalSize="compact"
        theme={darkTheme()}
      >
        <Component {...pageProps} />
      </RainbowKitProvider>
    </WagmiConfig>
  );
}
