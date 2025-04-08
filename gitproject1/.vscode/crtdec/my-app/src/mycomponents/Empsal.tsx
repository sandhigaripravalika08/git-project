//import React from 'react'

export default function EmpSal() {
    const empData = [
      { name: "Ramu", email: "ramu@gmail.com", company: "IBM", salary: 45000 },
      { name: "Raju", email: "raju@gmail.com", company: "HP", salary: 35000 },
      { name: "Ramya", email: "ramya@gmail.com", company: "InfoSys", salary: 25000 },
      { name: "John", email: "john@gmail.com", company: "Wipro", salary: 65000 },
      { name: "Abdul", email: "abdul@gmail.com", company: "TCS", salary: 55000 },
    
    ];
  
    // () => ()
  
    return (
      <div>
        <table className="table">
          <thead>
            <tr>
              <th scope="col">Name</th>
              <th scope="col">Email</th>
              <th scope="col">Company</th>
              <th scope="col">Salary</th>
            </tr>
          </thead>
          <tbody>
            {empData.map(
                (x)=>( 
                <tr>
                    <td>{x.name}</td>
                    <td>{x.email}</td>
                    <td>{x.company}</td>
                    <td>{x.salary}</td>
                  </tr>
                 )
            )}
           
          </tbody>
        </table>
      </div>
    );
  }