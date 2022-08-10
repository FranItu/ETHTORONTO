import { ConnectButton, RainbowKitProvider } from "@rainbow-me/rainbowkit";

const Navbar = () => {
  return (
    <>
      <div className="flex justify-between m-4">
        <div className="container  mx-auto content-center">
          <div className="flex flex-row" style={{ width: "600px" }}>
            <div className="w-10 mr-20">
              <a href="/">
                <img src="/images/logo.png" />
              </a>
            </div>
            <div className="flex-1" style={{ color: "#FDF3D0" }}>
              <a href="#">About</a>
            </div>
            <div className="flex-1" style={{ color: "#FDF3D0" }}>
              <a href="#">Featured</a>
            </div>
            <div className="flex-1" style={{ color: "#FDF3D0" }}>
              <a href="#">Top Categories</a>
            </div>
          </div>
        </div>
      </div>
      <div className="m-2">
        <ConnectButton />
      </div>
    </>
  );
};

export default Navbar;
