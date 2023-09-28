export function shortenAddress(inputString: string): string {
  if (inputString.length <= 8) {
    return inputString;
  } else {
    return inputString.slice(0, 4) + "…" + inputString.slice(-4);
  }
}
