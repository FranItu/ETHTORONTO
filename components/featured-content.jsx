export const FeaturedContent = (props) => {
  return (
    <div
      className="flex p-4 max-w-lg bg-white rounded-lg border border-gray-200 shadow-md gap-4"
      style={{ background: "#F2CDA2" }}
    >
      <div className="flex-1">
        <a href="#">
          <h5
            className="mb-2 text-xl font-bold tracking-tight text-gray-900 dark:text-white"
            style={{ color: "#BD4B31" }}
          >
            Featured Creator
          </h5>
        </a>
        <p className="font-bold" style={{ color: "black" }}>
          {props.creator}
        </p>
        <p className="mb-4 text-xs" style={{ color: "black" }}>
          {`${props.votes} vote(s)`}
        </p>
        <a href="#" style={{ color: "black" }}>
          {props.content}
        </a>
      </div>

      <div className="flex-1">
        <img className="rounded-lg" src={props.img} />
      </div>
    </div>
  );
};
