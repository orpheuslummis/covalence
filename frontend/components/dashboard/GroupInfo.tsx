

import { getNetwork, watchNetwork, writeContract, readContract} from "@wagmi/core";
import { GROUP_MANAGER_ABI, GROUP_MANAGER_CONTRACT } from "../../utils/Contracts";
import { useEffect, useState } from "react";
import { bytesToString } from "../../utils/stringToBytes";
import axios from "axios";
import { ethers } from "ethers";

export const GroupInfo = () => {

    const [groupName, setGroupName] = useState('')
    const [groupLogo, setGroupLogo] = useState('')
    const [members, setMembers] = useState<any>([])
    let id = 0;
    


    const getGroupInfo = async () => {
        try {

            const groupInfo: any = await readContract({
                address: GROUP_MANAGER_CONTRACT,
                abi: GROUP_MANAGER_ABI,
                functionName: "getGroupInfo",
                args: [0],
              });

              // console.log(groupInfo)

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

              setGroupLogo(groupData.groupLogo)
              setMembers(groupData.groupMembers)
            
        } catch (error) {
            
        }
    }

   

    useEffect(() => {
      getGroupInfo()
      
     
      
      
    
      // You can also return a cleanup function if needed
      return () => {
        // This code will run when the component unmounts
        // You can clean up any resources or subscriptions here
      };
      }, []); // The empty dependency array means this effect runs once, like componentDidMount
    
  
    return (
        <>
        <h1 className="text-2xl font-bold text-center">Group Info </h1>

<div className="max-w-5xl px-4 py-10 sm:px-6 lg:px-8 lg:py-14 mx-auto">
<div className="avatar avatar-ring-primary mr-5">
	<img src={`https://ipfs.io/ipfs/${groupLogo}`} alt="avatar" />
</div>
    <span className="font-bol text-xl py-5 mb-5 pb-5"> {groupName} </span>

    <div className="font-bol text-xl py-5 mb-5 pb-5"> Members</div>

    <div className="flex w-full overflow-x-auto mt-5">
	<table className="table-hover table">
		<thead>
			<tr>
				<th>SN</th>
				<th>Name</th>
				<th>Address</th>
				<th>Status</th>
			</tr>
		</thead>
		<tbody>
     {members.map((member: any) => (

      <tr key={1}>
      <th>{++id}</th>
      <td>{member.name}</td>
      <td>{member.wallet}</td>
      <td>Blue</td>
      </tr>

     ))}
       
			
			
		
		</tbody>
	</table>
</div>

<div className=" mt-7 divider my-0"></div>
<div className="font-bol text-xl py-5 mb-5 pb-5"> DISTRIBUTION AND EVALUATION RESULTS</div>

<div className="flex w-full overflow-x-auto">
	<table className="table-zebra table">
		<thead>
			<tr>
				<th>SN</th>
				<th>Address</th>
				<th>Percentage(%)</th>
				<th>Value</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th>1</th>
				<td>Ox...90</td>
				<td>40</td>
				<td>100 $</td>
			</tr>

			
		</tbody>
	</table>
</div>

</div>

        </>
    )
}