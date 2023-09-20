import TopNav from '../components/TopNav';
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
            // Render the details based on the selected item

            <>  
            <div className="p-4 text-center">{selectedItem}</div>
            
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