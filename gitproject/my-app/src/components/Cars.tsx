//import React from 'react'

export default function Car() {
 const empData = [
        { name: "thar",
         Manufacture: "Oct 10,2010",
         cost:"11.35 Lakh",
         image:"https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/Mahindra_Thar_Photoshoot_At_Perupalem_Beach_%28West_Godavari_District%2CAP%2CIndia_%29_Djdavid.jpg/420px-Mahindra_Thar_Photoshoot_At_Perupalem_Beach_%28West_Godavari_District%2CAP%2CIndia_%29_Djdavid.jpg"
          },
         {name:"Audi 8Al",
            Manufacture:"July,2022",
            cost:"1.34 Crores",
            image:"https://spn-sta.spinny.com/blog/20230612172549/Audi-A8-1160x653.webp?compress=true&quality=80&w=1200&dpr=1.3"
         },
         {name:"BMW",
            Manufacture:"Novenber 2020",
            cost:"1.03 Crores",
            image:"https://cdn.openart.ai/published/S768FagW6sigsNXjNxwG/yINYGvXw_I7zP_1024.webp"
         },
         {name:"Rolls Royce",
            Manufacture:"2013",
            cost:"5.00 Crores",
            image:"https://media.assettype.com/evoindia%2F2021-04%2Ffecd7495-9190-4f51-8faa-5ece8f0f883b%2FNovitec_Rolls_Royce_Wraith_2021_3__1_.jpg?w=1024&auto=format%2Ccompress&fit=max"
         },
         
         
 ];
         
 return (
    <div>
    <div className="row row-cols-1 row-cols-md-2 g-4">
      {empData.map((place) => (
        <div className="col" key={place.name}>
          <div className="card">
            <img src={place.image} width="1000" className="card-img-top" alt={place.name} />
            <div className="card-body">
              <h1 className="card-title">{place.name}</h1>
              <p className="card-text">{place.Manufacture}, {place.cost}</p>
            </div>
          </div>
        </div>
      ))}
    </div>
  </div>
 );
 }

  