import { NetworkErrorMessage } from "./NetworkErrorMessage";

export function ConnectWallet({ connectWallet, networkError, dismiss }) {
  return (
    <>
      <div>
        <div>
          {networkError && (
            <NetworkErrorMessage message={networkError} dismiss={dismiss} />
          )}
        </div>

        <p>Connect your wallet</p>
        <button type="button" onClick={connectWallet}>
          Connect wallet!
        </button>
      </div>
    </>
  );
}
