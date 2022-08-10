import { Button } from './button';
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
        <SecondaryButton>
        <a href='/how-does-it-work'>
          How does it work?
          </a>
          </SecondaryButton>
        <Button>
          <a href='/get-started'>
          Get started
          </a>
          </Button>
      </div>
    </div>
  );
};
