

import { getNetwork, watchNetwork, writeContract, readContract} from "@wagmi/core";
import { GROUP_MANAGER_ABI, GROUP_MANAGER_CONTRACT } from "../../utils/Contracts";
import { useState } from "react";
import { bytesToString } from "../../utils/stringToBytes";
import axios from "axios";
import { ethers } from "ethers";

export const GroupInfo = () => {

    const [groupName, setGroupName] = useState('')
    const [groupObj, setGroupObj] = useState(null)


    const getGroupInfo = async () => {
        try {

            const groupInfo: any = await readContract({
                address: GROUP_MANAGER_CONTRACT,
                abi: GROUP_MANAGER_ABI,
                functionName: "getGroupInfo",
                args: [2],
              });

            //   console.log(groupInfo)

              setGroupName(groupInfo[0])

           

              const CID = groupInfo[1] 
              console.log('CID: ',CID)
              let config: any = {
                method: "get",
                url: `https://${CID}.ipfs.w3s.link/file.json`,
                headers: {},
              };
              const axiosResponse = await axios(config);
    
              const groupData = axiosResponse.data;

              console.log('DATA: ',groupData)
            
        } catch (error) {
            
        }
    }

    getGroupInfo()

    return (
        <>
        <h1 className="text-2xl font-bold text-center">Group Info </h1>

<div className="max-w-5xl px-4 py-10 sm:px-6 lg:px-8 lg:py-14 mx-auto">
    <span className="font-bol text-xl py-5">Your Stats</span>

  

</div>

        </>
    )
}