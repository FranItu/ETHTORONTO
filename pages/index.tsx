import type { NextPage } from 'next';

import { ConnectButton } from '@rainbow-me/rainbowkit';
import { Hero } from '../components/hero';

const Home: NextPage = () => {
  return (
    <>
      <div className="flex justify-between">
        <div className="w-10">
          <img src="/images/logo.png" />
        </div>
        <ConnectButton />
      </div>
      <Hero />
    </>
  );
};

export default Home;
