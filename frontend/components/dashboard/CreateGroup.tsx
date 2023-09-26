
import React, { useState } from 'react';
import toast, {Toaster} from 'react-hot-toast';
import { GROUP_MANAGER_ABI, GROUP_MANAGER_CONTRACT } from '../../utils/Contracts';

import { getNetwork, watchNetwork, writeContract } from "@wagmi/core";
import { pushImgToStorage, putJSONandGetHash } from '../../utils/ipfsGateway';
import { stringToBytes } from '../../utils/stringToBytes';
import { ethers } from 'ethers';

export const CreateGroup = () => {
    const [members, setMembers] = useState([{ name: '', wallet: '' }]);
    const [showBtn, setShowBtn] = useState(true);

    const [groupName, setGroupName] = useState('');
    const [groupLogo, setGroupLogo] = useState<File | null>(null);
    
    const [logoUrl, setLogoUrl] = useState("");

    const handleGroupLogo = (e: any) => {
      setGroupLogo(e.target.files[0]);
      toast.success("Successfully added Image!");
      setLogoUrl(URL.createObjectURL(e.target.files[0]));
    };

    const handleAddMember = () => {
        if(members.length < 4) {
            setMembers([...members, { name: '', wallet: '' }]);
          }else {
            setShowBtn(false)
          }
      
    };

  

    const createGroup = async () => {
      try {

        const logoCID = await pushImgToStorage(groupLogo)
        console.log('**', logoCID)

        let initialMemberAddress = []
       for (let i = 0; i<members.length; i++) {
        const address = members[i].wallet;
        initialMemberAddress.push(address)
      }

        const groupObj = {
          groupName: groupName,
          groupLogo: logoCID,
          groupMembers: members,
        }
        console.log(groupObj)


        const groupCID = await putJSONandGetHash(groupObj)
        
        const { hash } = await writeContract({
          address: GROUP_MANAGER_CONTRACT,
          abi: GROUP_MANAGER_ABI,
          functionName: "createGroup",
          args: [groupName, groupCID, initialMemberAddress ],
        });
        
      } catch (error) {
        console.log(error)
        
      }
    }


  
    const handleMemberChange = (index: any, event: any) => {
      const updatedMembers = [...members] as any;
      updatedMembers[index][event.target.name] = event.target.value;
      
        setMembers(updatedMembers);
      
      
    };

    const clicker = () => {
      let initialMemberAddress = []
      for (let i = 0; i<members.length; i++) {
        const address = members[i].wallet;
        initialMemberAddress.push(address)
      }
      console.log(initialMemberAddress)
        console.log(members[0])
    }

    return (
        <>
       
<div className="max-w-4xl px-4 py-10 sm:px-6 lg:px-8 lg:py-14 mx-auto">
  
  <div className="bg-white rounded-xl shadow p-4 sm:p-7 dark:bg-slate-900">
    <div className="mb-8">
      <h2 className="text-xl font-bold text-gray-800 dark:text-gray-200">
        Create Group
      </h2>
      <p className="text-sm text-gray-600 dark:text-gray-400">
        create, manage your group and Team members
      </p>
    </div>

    <form>
     
      <div className="grid sm:grid-cols-12 gap-2 sm:gap-6">
        <div className="sm:col-span-3">
          <label className="inline-block text-sm text-gray-800 mt-2.5 dark:text-gray-200">
            Group Logo
          </label>
        </div>
       

        <div className="sm:col-span-9">
          <div className="flex items-center gap-5">
            <img className="inline-block h-16 w-16 rounded-full ring-2 ring-white dark:ring-gray-800" src={logoUrl || 'https://www.pngwing.com/en/search?q=user+Avatar'} alt="Image " />
            <div className="flex gap-x-2">
              <div>
                <input onChange={handleGroupLogo} type="file" className="py-2 px-3 inline-flex justify-center items-center gap-2 rounded-md border font-medium bg-white text-gray-700 shadow-sm align-middle hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-white focus:ring-blue-600 transition-all text-sm dark:bg-slate-900 dark:hover:bg-slate-800 dark:border-gray-700 dark:text-gray-400 dark:hover:text-white dark:focus:ring-offset-gray-800" />
              </div>
            </div>
          </div>
        </div>
      

        <div className="sm:col-span-3">
          <label htmlFor="af-account-full-name" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-gray-200">
            Group name
          </label>
          <div className="hs-tooltip inline-block">
            <button type="button" className="hs-tooltip-toggle ml-1 tooltip tooltip-top"  data-tooltip="The name of your group you wanna create">
              <svg className="inline-block w-3 h-3 text-gray-400 dark:text-gray-600" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"/>
              </svg>
            </button>
            <span >
              
            </span>
          </div>
        </div>
       

        <div className="sm:col-span-9">
          <div className="sm:flex">
            <input onChange={(e) => {setGroupName(e.target.value)}} id="af-account-full-name" type="text" className="py-2 px-3 pr-11 block w-1/2 border-gray-200 shadow-sm -mt-px -ml-px first:rounded-t-lg last:rounded-b-lg sm:first:rounded-l-lg sm:mt-0 sm:first:ml-0 sm:first:rounded-tr-none sm:last:rounded-bl-none sm:last:rounded-r-lg text-sm relative focus:z-10 focus:border-blue-500 focus:ring-blue-500 dark:bg-slate-900 dark:border-gray-700 dark:text-gray-400" placeholder="Encode Club" />
          </div>
        </div>
        
      </div>
      <div className="divider my-0"></div>
      <label htmlFor="af-account-full-name" className="inline-block text-sm text-gray-800 mt-2.5 dark:text-gray-200 my-4">
            Tean Members
          </label>
      {members.map((member, index) => (
              <div key={index} className="grid sm:grid-cols-12 gap-2 sm:gap-6">
                <div className="sm:col-span-6">
                  <label htmlFor={`name-${index}`} className="inline-block text-sm text-gray-800 mt-2.5 dark:text-gray-200">
                    Member Name
                  </label>
                  <input
                    type="text"
                    id={`name-${index}`}
                    name="name"
                    value={member.name}
                    onChange={(e) => handleMemberChange(index, e)}
                    className="py-2 px-3 pr-11 block w-full border-gray-200 shadow-sm -mt-px -ml-px first:rounded-t-lg sm:first:rounded-l-lg sm:mt-0 sm:first:ml-0 sm:first:rounded-tr-none text-sm relative focus:z-10 focus:border-blue-500 focus:ring-blue-500 dark:bg-slate-900 dark:border-gray-700 dark:text-gray-400"
                    placeholder="Alice"
                  />
                </div>
                <div className="sm:col-span-6">
                  <label htmlFor={`wallet-${index}`} className="inline-block text-sm text-gray-800 mt-2.5 dark:text-gray-200">
                    Wallet Address
                  </label>
                  <input
                    type="text"
                    id={`wallet-${index}`}
                    name="wallet"
                    value={member.wallet}
                    onChange={(e) => handleMemberChange(index, e)}
                    className="py-2 px-3 pr-11 block w-full border-gray-200 shadow-sm -mt-px -ml-px first:rounded-t-lg last:rounded-b-lg sm:last:rounded-r-lg text-sm relative focus:z-10 focus:border-blue-500 focus:ring-blue-500 dark:bg-slate-900 dark:border-gray-700 dark:text-gray-400"
                    placeholder="0x123...90"
                  />
                </div>
              </div>
            ))}
            <div className="mt-4">
             {showBtn && (
                 <button type="button" onClick={handleAddMember} className="py-2 px-3 inline-flex justify-center items-center gap-2 rounded-md border font-medium bg-blue-500 text-white hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all text-sm dark:focus:ring-offset-gray-800">
                 Add Member
               </button>
             )}
            </div>
     

      <div className="mt-5 flex justify-end gap-x-2">
      
        <button onClick={createGroup} type="button" className="py-2 px-3 inline-flex justify-center items-center gap-2 rounded-md border border-transparent font-semibold bg-blue-500 text-white hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all text-sm dark:focus:ring-offset-gray-800">
          Create Group
        </button>
      </div>
    </form>
  </div>
 
</div>

        </>
    )
}