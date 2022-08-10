import { ButtonHTMLAttributes, DetailedHTMLProps } from 'react';

export const Button = (
  props: DetailedHTMLProps<
    ButtonHTMLAttributes<HTMLButtonElement>,
    HTMLButtonElement
  >
) => {
  return (
    <button
      {...props}
      className={`bg-primary rounded-md py-2 px-8 font-bold drop-shadow ${
        props.className ?? ''
      }`}
    />
  );
};
