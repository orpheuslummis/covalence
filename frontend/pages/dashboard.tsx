import { CreateGroup } from "../components/dashboard/CreateGroup";
import { GroupInfo } from "../components/dashboard/GroupInfo";
import { Overview } from "../components/dashboard/Overview";
import { SideNav } from "../components/SideNav";
import { PleaseLogin } from "../components/PleaseLogin";
import { useAccount } from "wagmi";
import { useEffect, useState } from "react";

function Dashboard({
  contractAddress,
  contractABI,
}: {
  contractAddress: `0x${string}`;
  contractABI: any[];
}) {
  const { address } = useAccount();
  const [selectedItem, setSelectedItem] = useState(null);
  const [selectedId, setSelectedId] = useState(null);

  const handleSidebarItemClick = (item: any, id: any) => {
    setSelectedItem(item);
    console.log(id);

    // Update selectedId only if selectedItem is 'Group'
    if (item === "Group") {
      setSelectedId(id);
    }
  };

  useEffect(() => {}, [selectedId]);

  if (!address) {
    return <PleaseLogin />;
  } else {
    const content = () => {
      if (selectedItem === "general") {
        return (
          <Overview
            contractAddress={contractAddress}
            contractABI={contractABI}
            address={address}
          />
        );
      } else if (selectedItem === "create-group") {
        return (
          <CreateGroup
            contractAddress={contractAddress}
            contractABI={contractABI}
            address={address}
          />
        );
      } else if (selectedItem === "Group") {
        return (
          <GroupInfo
            currentID={selectedId}
            contractAddress={contractAddress}
            contractABI={contractABI}
            address={address}
          />
        );
      } else {
        return (
          <div className="mt-5 my-5 py-5">
            <Overview
              contractAddress={contractAddress}
              contractABI={contractABI}
              address={address}
            />
          </div>
        );
      }
    };

    return (
      <div className="flex">
        <SideNav
          contractAddress={contractAddress}
          contractABI={contractABI}
          onItemClick={handleSidebarItemClick}
          address={address}
        />
        <div className="flex-grow">
          <div className="p-4 text-center">{selectedItem}</div>
          {content()}
        </div>
      </div>
    );
  }
}

export default Dashboard;
