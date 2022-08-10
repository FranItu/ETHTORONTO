import { DetailedHTMLProps, ButtonHTMLAttributes } from 'react';

export const SecondaryButton = (
  props: DetailedHTMLProps<
    ButtonHTMLAttributes<HTMLButtonElement>,
    HTMLButtonElement
  >
) => {
  return (
    <button
      {...props}
      className={`bg-secondary text-primary rounded-md py-2 px-8 font-bold drop-shadow`}
    />
  );
};
