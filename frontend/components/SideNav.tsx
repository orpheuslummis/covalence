import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useAccount } from "wagmi";
import { shortenAddress } from "../utils/shortenAddress";
import { readContract } from "@wagmi/core";
import { useEffect, useState } from "react";

interface NavItem {
  onItemClick: any;
}
export const SideNav = ({
  onItemClick,
  contractAddress,
  contractABI,
  address,
}: NavItem & {
  contractAddress: `0x${string}`;
  contractABI: any[];
  address: string;
}) => {
  const [allGroups, setAllGroups] = useState<any[]>([]);
  const [groupIds, setGroupIds] = useState<any[]>([]);

  const getCurrentGroup = (id: any) => {
    try {
      const ids = Number(id);
      let name = "";

      for (let i = 0; i < allGroups.length; i++) {
        const arr = allGroups[i];
        name = arr[0];
      }
      return name;
    } catch (error) {
      console.log(error);
    }
  };

  const getUsersGroup = async () => {
    try {
      const groups: any = await readContract({
        address: contractAddress,
        abi: contractABI,
        functionName: "getGroupsOfUser",
        args: [address],
      });
      setGroupIds(groups);
      let tempGroup = [];

      if (groups) {
        for (let i = 0; i < groups.length; i++) {
          const data: any = await readContract({
            address: contractAddress,
            abi: contractABI,
            functionName: "getGroupInfo",
            args: [groups[i]],
          });
          tempGroup.push(data);
        }
        setAllGroups(tempGroup);
        console.log(groupIds);
      }
    } catch (error) {
      console.log(error);
    }
  };

  useEffect(() => {
    getUsersGroup();

    // You can also return a cleanup function if needed
    return () => {
      // This code will run when the component unmounts
      // You can clean up any resources or subscriptions here
    };
  }, []); // The empty dependency array means this effect runs once, like componentDidMount

  return (
    <>
      <div className="flex flex-row sm:gap-10">
        <div className="sm:w-full sm:max-w-[18rem]">
          <input
            type="checkbox"
            id="sidebar-mobile-fixed"
            className="sidebar-state"
          />
          <label
            htmlFor="sidebar-mobile-fixed"
            className="sidebar-overlay"
          ></label>
          <aside className="sidebar sidebar-fixed-left sidebar-mobile h-full justify-start max-sm:fixed max-sm:-translate-x-full">
            <section className="sidebar-title items-center p-4">
              <div className="flex flex-col">
                <a href="/dashboard">
                  <span className="text-2xl font-bold cursor-pointer">
                    Covalence
                  </span>
                </a>
              </div>
            </section>
            <section className="sidebar-content">
              <nav className="menu rounded-md">
                <section className="menu-section px-4">
                  <span className="menu-title">Main menu</span>
                  <ul className="menu-items">
                    <li
                      className="menu-item menu-active"
                      onClick={() => onItemClick("general")}
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        className="h-5 w-5 opacity-75"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                        strokeWidth="2"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
                        />
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                        />
                      </svg>
                      <span>General</span>
                    </li>

                    <li
                      className="menu-item "
                      onClick={() => onItemClick("create-group")}
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        className="h-5 w-5 opacity-75"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                        strokeWidth="2"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"
                        />
                      </svg>
                      <span>Create Group</span>
                    </li>
                    <li
                      className="menu-item"
                      onClick={() => onItemClick("contribut-coming-soon")}
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        className="h-5 w-5 opacity-75"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                        strokeWidth="2"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"
                        />
                      </svg>
                      <span>Contribute</span>
                    </li>
                    <li>
                      <input
                        type="checkbox"
                        id="menu-1"
                        className="menu-toggle"
                      />
                      <label
                        className="menu-item justify-between"
                        htmlFor="menu-1"
                      >
                        <div className="flex gap-2">
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            className="h-5 w-5 opacity-75"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke="currentColor"
                            strokeWidth="2"
                          >
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                            />
                          </svg>
                          <span>Your Groups</span>
                        </div>

                        <span className="menu-icon">
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            className="h-5 w-5"
                            viewBox="0 0 20 20"
                            fill="currentColor"
                          >
                            <path
                              fillRule="evenodd"
                              d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                              clipRule="evenodd"
                            />
                          </svg>
                        </span>
                      </label>

                      <div className="menu-item-collapse">
                        <div className="min-h-0">
                          {/* <label  className="menu-item menu-item-disabled ml-6">Open-Data-Hack-TeamPluto</label>
										<label onClick={() => onItemClick('Group')} className="menu-item ml-6">ETH Global-TeamBTC</label>
										<label className="menu-item ml-6">TeamEthers</label> */}
                          {groupIds.map((id) => (
                            <label
                              key={id}
                              onClick={() => onItemClick("Group", id)}
                              className="menu-item ml-6"
                            >
                              {getCurrentGroup(id)}
                            </label>
                          ))}
                        </div>
                      </div>
                    </li>
                  </ul>
                </section>
                <div className="divider my-0"></div>
                <section className="menu-section px-4">
                  <span className="menu-title">Utility</span>
                  <ul className="menu-items">
                    <li className="menu-item">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        className="opacity-75"
                        width="22"
                        height="22"
                        viewBox="0 0 24 24"
                        strokeWidth="2"
                        stroke="currentColor"
                        fill="none"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <path
                          stroke="none"
                          d="M0 0h24v24H0z"
                          fill="none"
                        ></path>
                        <path d="M3 21l18 0"></path>
                        <path d="M3 10l18 0"></path>
                        <path d="M5 6l7 -3l7 3"></path>
                        <path d="M4 10l0 11"></path>
                        <path d="M20 10l0 11"></path>
                        <path d="M8 14l0 3"></path>
                        <path d="M12 14l0 3"></path>
                        <path d="M16 14l0 3"></path>
                      </svg>
                      Vault
                    </li>

                    <li className="menu-item">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        className="opacity-75"
                        width="22"
                        height="22"
                        viewBox="0 0 24 24"
                        strokeWidth="2"
                        stroke="currentColor"
                        fill="none"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <path
                          stroke="none"
                          d="M0 0h24v24H0z"
                          fill="none"
                        ></path>
                        <path d="M7 10l5 -6l5 6"></path>
                        <path d="M21 10l-2 8a2 2.5 0 0 1 -2 2h-10a2 2.5 0 0 1 -2 -2l-2 -8z"></path>
                        <path d="M12 15m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0"></path>
                      </svg>
                      Contributions
                    </li>
                  </ul>
                </section>
              </nav>
            </section>
            <section className="sidebar-footer justify-end bg-gray-2 pt-2">
              <div className="ml-5 mr-6 "></div>
              <div className="divider my-0"></div>
              <div className="dropdown z-50 flex h-fit w-full cursor-pointer hover:bg-gray-4	">
                <label
                  className="whites mx-2 flex h-fit w-full cursor-pointer p-0 hover:bg-gray-4"
                  tabIndex={0}
                >
                  <div className="flex flex-row gap-4 p-4">
                    <div className="avatar-square avatar avatar-md">
                      <img
                        src="https://i.pravatar.cc/150?img=30"
                        alt="avatar"
                      />
                    </div>

                    <div className="flex flex-col">
                      <span>{shortenAddress(address)}</span>
                    </div>
                  </div>
                </label>
                <div className="dropdown-menu-right-top dropdown-menu ml-1  w-full">
                  <a className="dropdown-item text-sm">
                    <ConnectButton showBalance={false} />
                  </a>
                </div>
              </div>
            </section>
          </aside>
        </div>
        <div className="flex w-full flex-col p-4">
          <div className="w-fit">
            <label
              htmlFor="sidebar-mobile-fixed"
              className="btn-primary btn sm:hidden"
            >
              Open Sidebar
            </label>
          </div>
        </div>
      </div>
    </>
  );
};
