import type { NextPage } from "next";

import { ConnectButton } from "@rainbow-me/rainbowkit";
import { Title } from "../components/title";
import ListPoint from "../components/listpoint";

const HowDoesItWork: NextPage = () => {
  return (
    <>
      <Title />
      <img src="/images/Top-Banner-Background.svg" style={{position: "absolute"}}/>
      <div style={{background: "black", height: "1200px"}}>
        <div className="mx-20" style={{transform: "translate(0px, 200px)"}}>
        <div>
          <div className="uppercase" style={{color: "#FDF3D0", fontSize: "x-large", fontWeight: "bold"}}>
            How Does
          </div>
          <div className="uppercase" style={{color: "#BD4B31", fontSize: "x-large", fontWeight: "bold"}}>
          Calliope Work?
          </div>
        </div>
        <ListPoint content={"Content creators create rentable NFTs with Calliope."} num={1}/>
        <ListPoint content={`Content creators rent their NFTs for a month at their decided fare.

            a. NFTs are used for exclusive content during the monthly subscription, along with a voting token that allow renters to decide where funds get redistributed.

            b. The voting token is single use and lasts for the whole time the renter holds the token.
            `} num={2}/>
        <ListPoint content={`99% of the revenue goes back to the content creator. 
1% goes to a common pool.
            `} num={3}/>
        <ListPoint content={`At the end of each month the pool gets redistributed to the place where most renters vote. Calliope gets 5% from this pool as revenue.`} num={4}/>
        <ListPoint content={`The rented NFTs go back automatically to the content creator at the end of the month.`} num={5}/>
        </div>

        <img src="/images/Cool-Loopy-Image.svg" style={{position: "absolute", height: "600px"}}/>
      </div>
    </>
  );
};

export default HowDoesItWork;
