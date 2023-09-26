import {CreateGroup} from '../components/dashboard/CreateGroup';
import { GroupInfo } from '../components/dashboard/GroupInfo';
import { Overview } from '../components/dashboard/Overview';
import {SideNav} from '../components/SideNav';
import { useState } from 'react';


//  function Dashboard  () {

//     return (
//         <> 
        
//         <SideNav />
//         <h1 className="text-center">HELLO</h1>
//                 </>
//     )
// }

// export default Dashboard;
function Dashboard() {
    const [selectedItem, setSelectedItem] = useState(null);
  
    // Function to handle the sidebar item click
    const handleSidebarItemClick = (item: any) => {
      setSelectedItem(item);
    };
  
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

            {selectedItem == 'Group' && (
               
               <GroupInfo />
                 
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