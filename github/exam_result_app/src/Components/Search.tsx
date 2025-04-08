import React from 'react'

export default function Search() {
  return (
    <div>Search
      <div className="container">
   <div className="search"> 
    <div className="row"> 
      <div className="col-md-6"> 
        <div className="search-1"> 
          <i className='bx bx-search-alt'>
            </i> <input type="text" 
            placeholder="UX Designer"/> 
            </div> </div> 
            <div
             className="col-md-6"> 
             <div> <div className="search-2"> 
              <i className='bx bxs-map' ></i> 
              <input type="text" 
              placeholder="San Francisco,USA"/>
               <button>Search</button> 
               </div> </div> </div>
                </div> </div>
</div>
    </div>
  )
}
