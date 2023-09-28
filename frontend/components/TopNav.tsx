import { ConnectButton } from "@rainbow-me/rainbowkit";
import Link from "next/link";

const TopNav = () => {
  return (
    <div className="navbar rounded-lg">
      <div className="navbar-start">
        <a className="navbar-item font-bold text-3xl pr-9">Covalence</a>
        <div className="pl-25 navbar-center">
          <a href="" className="navbar-item">
            {" "}
            How It Works
          </a>
          <a href="" className="navbar-item">
            {" "}
            FAQs
          </a>
          <a href="" className="navbar-item">
            {" "}
            Team
          </a>
          <a href="" className="navbar-item">
            {" "}
            Blog
          </a>
        </div>
      </div>

      <div className="navbar-end">
        <ConnectButton
          chainStatus="icon"
          showBalance={false}
          accountStatus={{
            smallScreen: "avatar",
            largeScreen: "full",
          }}
        />

        {/* profile avatar */}
        <div className="avatar avatar-ring avatar-md">
          <div className="dropdown-container">
            <div className="dropdown">
              <label
                className="btn btn-ghost flex cursor-pointer px-0"
                tabIndex={0}
              >
                <img
                  src="https://i.pravatar.cc/150?u=a042581f4e29026024d"
                  alt="avatar"
                />
              </label>
              <div className="dropdown-menu dropdown-menu-bottom-left">
                <Link href="/dashboard" className="dropdown-item text-sm">
                  Dashboard
                </Link>
                <a tabIndex={-1} className="dropdown-item text-sm">
                  Account settings
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
export default TopNav;
