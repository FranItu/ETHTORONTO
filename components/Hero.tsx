import { Button } from './Button';
import { SecondaryButton } from './secondary-button';

export const Hero = () => {
  return (
    <div className="w-full">
      <div className="flex mx-auto w-fit">
        <img src="/images/logo.png" />
        <p className="my-auto text-6xl font-bold">alliope</p>
      </div>

      <p className="text-xl text-center mt-8">
        Connecting independent content creators to funding and fans through
        rentable NFTs.
      </p>

      <div className="mt-8 flex gap-8 w-fit mx-auto">
        <SecondaryButton>How does it work?</SecondaryButton>
        <Button>Get started</Button>
      </div>
    </div>
  );
};
