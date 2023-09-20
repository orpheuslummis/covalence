import {CreateGroup} from '../components/dashboard/CreateGroup';
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
    const handleSidebarItemClick = (item) => {
      setSelectedItem(item);
    };
  
    return (
      <div className="flex">
        <SideNav onItemClick={handleSidebarItemClick} />
        <div className="flex-grow">
          {selectedItem ? (
            

            <>  
            <div className="p-4 text-center">{selectedItem}</div>
            {/* Create Group */}
            {selectedItem == 'create-group' && (
               
              <CreateGroup />
                
            )}


            
            </>
            
            
          ) : (
            // Default content when no item is selected
            <h1 className="text-center">HELLO</h1>
          )}
        </div>
      </div>
    );
  }
  
  export default Dashboard;