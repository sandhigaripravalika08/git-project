

//import React from 'react'

export default function Wonders() {
    const empData = [
        { name: "Taj Mahal",
         location: "Agra",
         country: "India",
         image:"https://cdn1.matadornetwork.com/blogs/1/2018/02/Taj-Mahal.jpg"
          },
         {name:"Great wall of China",
            location:"Multiple locations",
            country:"China",
            image:"https://i0.wp.com/triptometer.com/wp-content/uploads/2023/08/The-Great-Wall-of-China-1.jpg?w=1200&ssl=1"
         },
         {name:"Petra",
            location:"Ma'an Governorate",
            country:"Jordan",
            image:"https://i0.wp.com/triptometer.com/wp-content/uploads/2023/08/Petra-Jordan.jpg?w=1200&ssl=1"
         },
         {name:"Christ the Redeemer",
            location:"Rio De Janeiro",
            country:"Brazil",
            image:"https://i0.wp.com/triptometer.com/wp-content/uploads/2023/08/Christ-the-Redeemer.jpg?w=1200&ssl=1"
         },
         {name:"Machu Picchu",
            location:"Cusco Region",
            country:"Peru",
            image:"https://i0.wp.com/triptometer.com/wp-content/uploads/2023/08/Machu-Picchu.jpg?resize=768%2C402&ssl=1"
         },
         {name:"Chichen Itza",
            location:"Yucatan",
            country:"Mexico",
            image:"https://i0.wp.com/triptometer.com/wp-content/uploads/2023/08/Chichen-Itza.jpg?resize=768%2C402&ssl=1"
         },
         {name:"Colosseum",
            location:"Rome",
            country:"Italy",
            image:"https://i0.wp.com/triptometer.com/wp-content/uploads/2023/08/Colosseum-Italy.jpg?resize=768%2C402&ssl=1"
         },
        
      ];
  return (
    <div>
        <div className="row row-cols-1 row-cols-md-2 g-4">
     {empData.map((place) => (
       <div className="col" key={place.name}>
         <div className="card">
           <img src={place.image} className="card-img-top" alt={place.name} />
           <div className="card-body">
             <h5 className="card-title">{place.name}</h5>
             <p className="card-text">{place.location}, {place.country}</p>
           </div>
         </div>
       </div>
     ))}
   </div>
 </div>
);
}