import { ConnectButton, RainbowKitProvider } from "@rainbow-me/rainbowkit";

const Navbar = () => {
  return (
    <>
      <div className="flex justify-between">
        <div className="container  mx-auto content-center">
          <div className="flex flex-row" style={{ width: "700px" }}>
            <div className="w-10 mr-20">
              <img src="/images/logo.png" />
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
            <div className="flex-1">
              <ConnectButton />
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Navbar;
