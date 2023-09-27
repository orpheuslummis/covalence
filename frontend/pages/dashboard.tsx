import {CreateGroup} from '../components/dashboard/CreateGroup';
import { GroupInfo } from '../components/dashboard/GroupInfo';
import { Overview } from '../components/dashboard/Overview';
import {SideNav} from '../components/SideNav';
import { useEffect, useState } from 'react';



function Dashboard() {
    const [selectedItem, setSelectedItem] = useState(null);
    const [selectedId, setSelectedId] = useState(null);

        // Function to handle the sidebar item click
        const handleSidebarItemClick = (item: any, id: any) => {
          setSelectedItem(item);
          console.log(id)


          // Update selectedId only if selectedItem is 'Group'
    if (item === 'Group') {
      setSelectedId(id);
    }
        };
  
        useEffect(() => {
          // Your logic here based on selectedItem
          // For example, you can fetch data or perform actions when selectedItem changes
          // You can switch based on selectedItem and render different components
          // or perform any other actions you need.
          
      
        }, [selectedId]); 
    
  
    return (
      <div className="flex">
        <SideNav onItemClick={handleSidebarItemClick} />
        <div className="flex-grow">
          {selectedItem ? (
            

            <>  
            <div className="p-4 text-center">{selectedItem}</div>
            {selectedItem == 'general' && (
               
               <Overview />
                 
             )}
            {/* Create Group */}
            {selectedItem == 'create-group' && (
               
              <CreateGroup />
                
            )}

            { selectedItem == 'Group' &&(
               
               <GroupInfo currentID={selectedId}/>
                 
             )}
            


            
            </>
            
            
          ) : (
            // Default content when no item is selected
            <>
            <div className='mt-5 my-5 py-5'>
            <Overview />

            </div>
               </>
                
           
          )}
        </div>
      </div>
    );
  }
  
  export default Dashboard;