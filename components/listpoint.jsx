import { ConnectButton, RainbowKitProvider } from "@rainbow-me/rainbowkit";

const ListPoint = (props) => {
  return (
    <>
      <div className="flex gap-8 my-5">
        <div className="flex-2">
          <div
            style={{
              backgroundColor: "#FFF2CC",
              borderRadius: "50%",
              width: "100px",
              aspectRatio: "1/1",
            }}
          >
            <div
              style={{
                backgroundColor: "black",
                borderRadius: "50%",
                width: "80px",
                aspectRatio: "1/1",
                transform: "translate(10px, 10px)",
                justifyContent: "center",
              }}
            >
              <div
                style={{
                  color: "#D08370",
                  transform: "translate(35%, 4%)",
                  fontSize: "3em",
                  fontWeight: "600",
                }}
              >
                {props.num}
              </div>
            </div>
          </div>
        </div>
        <div className="flex-2">{props.content}</div>
      </div>
    </>
  );
};

export default ListPoint;
