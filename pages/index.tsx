import type { NextPage } from 'next';

import { ConnectButton } from '@rainbow-me/rainbowkit';
import { Hero } from '../components/hero';
import {FeaturedContent} from '../components/featured-content'

const Home: NextPage = () => {
  return (
    <>
      <Hero />
      <FeaturedContent creator={"Francisco"} votes={40} content={`
      Born in Equador, Francisco discovered AI art at age 19 and has since created a collection of intriguing abstract art to share.
      `} img={"images/AntMigration_Dali_2_0.jpg"}/>
    </>
  );
};

export default Home;
