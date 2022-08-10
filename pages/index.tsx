import type { NextPage } from 'next';

import { ConnectButton } from '@rainbow-me/rainbowkit';

export const YourApp = () => {
  return;
};

const Home: NextPage = () => {
  return (
    <>
      <div className="flex justify-between">
        <h1 className="text-3xl font-bold underline">Hello world!</h1>
        <ConnectButton />
      </div>
    </>
  );
};

export default Home;
