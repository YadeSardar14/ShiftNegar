
const host = "http://127.0.0.1:5000";
var name;
var Username;
var UserID;
var isAdmin;
var AllShifts = null;
var AllHourWorks = null;
var RequestData;
var Shifts = {};
var Departments = {};
var Persennols = [];

(()=> {
    let data = GetCookie("data");
    if (!data)
    window.location = host+"/SingIn";
    else{
        data = JSON.parse(data);
        name = data[1];
        Username = GetCookie("username");
        UserID = data[2];
        isAdmin = Boolean(data[0]);
        document.querySelector("p.user").innerHTML = name;
     
        document.querySelector("form.adminshifthandel").style.display = "none";
        document.querySelector("form.adminuserhandel").style.display = "none";
        document.querySelector("form.adminrequesthandel").style.display = "none";

        document.querySelector("div.saveshiftalert").classList.add("hide");
        document.querySelector("div.changeAdminalert").classList.add("hide");
          
        
        document.querySelector("div.info div#req_select").style.display = "none"
        document.querySelector("table.myrequests").style.display = "none";
        document.querySelector("div#back_btn").style.display = "none";
        SetMainPage();
    }

   
})()


function GetCookie(key){
    if(document.cookie){
    let data = document.cookie.split(key+"=")[1].split(";")[0];
    return data;}
    return null;
}


function showAlert(event){
    event.classList.remove("hidefect")
    event.classList.remove("hide")
    void event.offsetWidth;
    event.classList.add("vis");
    event.classList.add("hidefect");
}


function AddRow(table,rowText,data = null,type = "main"){

    const newRow = document.createElement("tr");
    const headers = table.parentElement.querySelectorAll("thead th");
    const dep_id = document.querySelector("select.dep")

    rowText.forEach((cell,i) => {
        const td = document.createElement("td");
        td.textContent = cell;

        if(data){

        if(type == "main"){
        const username = data;
        if(cell==="OFF") td.style.color = "rgba(255, 20, 0, 0.56)";
        td.id = JSON.stringify({"username" : username , "day" : headers[i].id, "selectValue" : dep_id.value , "isAdmin" : Persennols[username]["isAdmin"]});
        
        }else if (type == "request"){

            td.id = JSON.stringify(data);
        }

        }

        newRow.appendChild(td);
    });

    table.appendChild(newRow);

}


function SetDepartments(data){

    let dep = document.querySelector("select.dep");
    data.forEach(ob => {
        Departments[ob["DepartmentsID"]] =  ob["name"];

        let op = document.createElement("option");
        op.innerHTML = ob["name"];
        op.value = ob["DepartmentsID"];
        dep.appendChild(op);
    })
    
}


function SetShifts(data){
   
    const shifts = document.querySelector("div#shifts");
    data.forEach(shift => {
        Shifts[shift["ShiftsID"]] = shift["type"];

        if(shift["ShiftsID"] !== 0){
        let p = document.createElement("p");
        p.innerHTML =shift["type"]+ " : " + shift["startTime"]+ " to " +shift["endTime"] ;
        p.value = shift["ShiftsID"];
        shifts.appendChild(p);  }
    })

}


function ChangeRequest(data){
console.log(data)
data = {
    "RequestlogID" : data.slice(-1)[0],
    "adminAction" : name,
    "status" : data[6],
    "type" : data[1],
    "username" : data.slice(-2)[0],
    "ShiftsID" : JSON.parse(data[2]),
    "DepartmentsID" : data[4],
    "day" : data[3]
}
    
fetch(host+"/SetData/ChangeRequest",{
    method : "POST",
    headers: { 'Content-Type': 'application/json',},
    body : JSON.stringify(data)
})
.then(response => {
    if (response.ok){
        showAlert(document.querySelector("div.saveshiftalert"));
        return response.json();
    
    }else
    console.error("save Conn Ereor");
    
})
.catch(er=>{
    console.error("Save Fetch Ereor");
});

}

function adminRequestHandler(td){

const data = JSON.parse(td.id);
const status = JSON.parse(data[2]);

const form = document.querySelector("form.adminrequesthandel");
form.style.display = "flex";

const lable = form.querySelector("label");
lable.innerHTML = "درخواست " + data[0] + ((data[0] !== "مرخصی" )?" شیفت":" بخش");


const btnACCEPT = form.querySelector("button#accept");
const btnREJECT = form.querySelector("button#reject");


btnACCEPT.onclick = ()=>{

    data[6] = "accept";
    ChangeRequest(data);
};

btnREJECT.onclick = ()=>{

    data[6] = "reject";
    ChangeRequest(data);

};


}


var lastshiftstate = [];
function adminShiftHandler(td,day){

    const form = document.querySelector("form.adminshifthandel");
    form.querySelector("label.user").id = td.id;
    
    form.querySelectorAll("input.ch").forEach(ch=>{
        ch.checked = false;
        if(td.innerHTML.includes(Shifts[ch.id])) ch.checked = true;

        lastshiftstate.push(ch.checked);
    });
    
    form.style.display = "flex";
}

function SaveNewShift(){
    
    const form = document.querySelector("form.adminshifthandel");
    const user = form.querySelector("label.user");

    let newState = [];
    form.querySelectorAll("input.ch").forEach(ch=>newState.push(ch.checked));
    
    if(JSON.stringify(newState) == JSON.stringify(lastshiftstate)){
        lastshiftstate = [];
        form.style.display = "none";
        user.id = null;
        return;    }

    
    let shiftIDs = [];
    form.querySelectorAll("input.ch").forEach(ch=>{    
        if(ch.checked)
        shiftIDs.push(ch.id);
    });

    if (!(newState.includes(true))) shiftIDs = [0];


    if(user.id){

fetch(host+"/SetData/SaveShift",{
    method : "POST",
    headers: { 'Content-Type': 'application/json',},
    body : JSON.stringify([JSON.parse(user.id),shiftIDs])
})
.then(response => {
    if (response.ok){
        showAlert(document.querySelector("div.saveshiftalert"));
        return response.json();
    
    }else
    console.error("save Conn Ereor");
    
})
.catch(er=>{
    console.error("Save Fetch Ereor");
});

    }

    lastshiftstate = [];
    form.style.display = "none";
    user.id = null;

    
    setTimeout(()=>{SetTable(reLoade=true); 
                    SetWorkHours();
    },500);

}



function adminUserHandler(td){
    const data =  JSON.parse(td.id);
    const form = document.querySelector("form.adminuserhandel");
    
    if (!form.innerHTML){
    form.style.display = "flex";
    for (let node of JSON.parse(AllShifts)){ 
        if (data["username"] == node.pop()){
        form.innerHTML += "<h style='padding-bottom: 0.5rem;'>"+node[0]+"</h>"+"<p> سمت : "+node[1]+"</p>"+"<p> قرارداد : "+(node[2] == "hourly"?"ساعتی":node[2] == "official"? "رسمی" : node[2])+"</p>";
        break;}
    }

    const btn = document.createElement("button");
    btn.classList.add("btn")
    btn.onclick = ()=>{adminup(data["isAdmin"],data["username"]);}

    if(data["isAdmin"])
    btn.innerHTML = "حذف دسترسی به پنل مدیریت";
    else
    btn.innerHTML = "اجازه دسترسی به پنل مدیریت"
    
    form.appendChild(btn);


    }else{
        
        form.innerHTML = "";
        form.style.display ="none"

    }
    
}


function adminup(isAdmin,username) {

fetch(host+"/SetData/ChangeAdmin",{
    method : "POST",
    headers: { 'Content-Type': 'application/json',},
    body : JSON.stringify([isAdmin,username])
})
.then(response => {
    if (response.ok){
        showAlert(document.querySelector("div.changeAdminalert"));
        return response.json();
    
    }else
    console.error("save Conn Ereor");
    
})
.catch(er=>{
    console.error("Save Fetch Ereor");
})

    }
    


function SetNoShiftPersonnels(tbody){

fetch(host+"/GetData/GetPersonnels",{
    method: 'GET',
headers: { 'Content-Type': 'application/json',}})
.then(response => {
    if (response.ok)
    return response.json();

    else
    return "ERooooR";  })  

.then(response => {
    

    if(response){
        if (!Persennols[0]) Persennols = response;

        let currentUsers = []
        const trs = tbody.querySelectorAll("tr")
        trs.forEach(tr=>{ 
            const tdID = tr.querySelector("td").id;
            currentUsers.push(JSON.parse(tdID)["username"]) })
        
        for (key in response){
            if (!currentUsers.includes(response[key]["username"]))
            AddRow(tbody,[response[key]["name"],"-","-",null,null,null,null,null,null,null],response[key]["username"])
            }
    

    }else
    console.log("Data Error . . . !");
    
    })  
.catch(er => {
        console.log("Fetch Error");
    });
}



function SetRequestTableEvent(table) {
    
let tds = table.querySelectorAll("td");
let headers = table.querySelectorAll("thead th");

let i = 0;
tds.forEach((td) => {
    if(i==headers.length) i=0;
        if (headers[i].className=="status"){
        td.addEventListener("click",()=>{adminRequestHandler(td);});
        td.addEventListener("mouseenter",()=>{td.classList.add("tdhoverefect"); });
        td.addEventListener("mouseleave",()=>{td.classList.remove("tdhoverefect"); });


        if(td.textContent == "رد شده") td.style.backgroundColor = "rgba(255, 140, 140, 0.699)";
        else if (td.textContent == "تایید شده") td.style.backgroundColor = "rgba(103, 255, 154, 0.699)";
        else td.style.backgroundColor = "rgba(139, 160, 255, 0.705)";
        }

    i++;
    });

}

function SetTableRequests(st = "current"){

const my_table = document.querySelector("table."+"myrequests");
let my_tbody = my_table.querySelector("tbody");
my_tbody.remove();
my_tbody = document.createElement("tbody");
my_table.appendChild(my_tbody);
    
fetch(host+"/GetData/GetRequestsForAdmin",{
method: 'GET',
headers: { 'Content-Type': 'application/json',}})
.then(response => {
    if (response.ok)
    return response.json();

    else
    return "ERooooR";  })  

.then(response => {
    if (response[0]){
    for(let req of response){
       
        if (st == "current" && req[5]!= "current")
        continue;
        else if (st == "checked" && req[5] == "current")
        continue;

        let status = JSON.parse(req[1]);
        let typeText = (req[0]=="get")?"افزودن":(req[0]=="remove")?"حذف":(req[0]=="change")?"تغییر":(req[0]=="off")?"مرخصی":"";           
        
        let row = [
                req[6],
                typeText,
                (req[0]=="get")?Shifts[status[0]]:(req[0]=="remove")?Shifts[status[0]]:(req[0]=="change")?Shifts[status[0]]+" ⭢ "+Shifts[status[1]]:"",
                (req[2]==="0")?"شنبه":(req[2]==="1")?"یکشنبه":(req[2]==="2")?"دوشنبه":(req[2]==="3")?"سه‌شنبه":(req[2]==="4")?"چهارشنبه":(req[2]==="5")?"پنجشنبه":(req[2]==="6")?"جمعه":"",
                Departments[req[3]],
                req[4],
                (req[5] == "current")?"جاری":(req[5] == "reject")?"رد شده":(req[5] == "accept")?"تایید شده":""
            ];

        AddRow(my_tbody,row,[typeText].concat(req),"request");
    }
    SetRequestTableEvent(my_table);
    }})  
.catch(er => {
        console.log("Fetch Error");
    });
}


function SetTableEvent(table) {

    
let tds = table.querySelectorAll("td");
let headers = table.querySelectorAll("thead th");

let i = 0;
tds.forEach((td) => {
    if(i==headers.length) i=0;

        if (headers[i].className=="day"){
        td.onclick= ()=>{adminShiftHandler(td);};
        td.style.backgroundColor = "rgba(131, 255, 193, 0.849)";
        td.addEventListener("mouseenter",()=>{td.classList.add("tdhoverefect"); });
        td.addEventListener("mouseleave",()=>{td.classList.remove("tdhoverefect"); });
        
        }else if (headers[i].className=="name"){
        td.onclick = ()=>{adminUserHandler(td);};
        td.addEventListener("mouseenter",()=>{td.classList.add("tdhoverefect"); });
        td.addEventListener("mouseleave",()=>{td.classList.remove("tdhoverefect"); });
        
        if(JSON.parse(td.id)["isAdmin"])
        td.style.backgroundColor = "rgba(131, 200, 120, 0.849)";
        else
        td.style.backgroundColor = "rgba(131, 200, 193, 0.849)";
    
        }

    i++;
    });
    
}


function SetTable(reLoade = false){

const table = document.querySelector("table."+"main");
let tbody = table.querySelector("tbody");
tbody.remove();
tbody = document.createElement("tbody");
table.appendChild(tbody);

if (AllShifts && !reLoade){

    const dep = document.querySelector("select.dep");
    const all = JSON.parse(AllShifts);

    let customWorkHours = {};
    AllHourWorks.forEach(ob=>{ customWorkHours[ob["username"]]=[ob["worktime"],ob["state"]]});
   
    all.forEach(row => {


        let username = row.pop(); 
        let user_dep = row.pop(); 
        
        if (user_dep == dep.value)
        AddRow(tbody,[row[0]].concat(customWorkHours[username].concat(row.slice(3))),username);
    
        });
    
    SetNoShiftPersonnels(tbody);
    setTimeout(()=>{SetTableEvent(table)},500);
    
}else{

fetch(host+"/GetData/GetTable",{
    method: 'GET',
headers: { 'Content-Type': 'application/json',}})
.then(response => {
    if (response.ok)
    return response.json();

    else
    return "ERooooR";  })  

.then(response => {
    
    let dep = document.querySelector("select.dep");
    if (response[0]){
    if (response[0] == "noData"){

        for (key in Persennols)
            AddRow(tbody,[Persennols[key]["name"],"-","-",null,null,null,null,null,null,null],Persennols[key]["username"])
            

    }else {

    AllShifts = JSON.stringify(response);
    let customWorkHours = {};
    AllHourWorks.forEach(ob=>{ customWorkHours[ob["username"]]=[ob["worktime"],ob["state"]]});
   
    response.forEach(row => {
        const username = row.pop(); 
        let user_dep = row.pop(); 

        if (user_dep == dep.value)
        AddRow(tbody,[row[0]].concat(customWorkHours[username].concat(row.slice(3))),username);
        
        SetNoShiftPersonnels(tbody)
    }); }

    setTimeout(()=>{SetTableEvent(table)},500);

    }else
    console.log("Data Error . . . !");
    
    })  
.catch(er => {
        console.log("Fetch Error");
    });

}}

function SetWorkHours(){

    fetch(host+"/GetData/GetHourWorkState",{
method: 'GET',
headers: { 'Content-Type': 'application/json',}})
.then(response => {
    if (response.ok)
    return response.json();

    else
    return "ERooooR";  })  

.then(response => {
    
    if (response[0])
    AllHourWorks = response;

    else
    console.log("Data Error . . . !");
    
    })  
.catch(er => {
        console.log("Fetch Error");
    });

}

function SetMainPage(){

fetch(host+"/GetData/GetDepartment",{
    method: 'GET',
headers: { 'Content-Type': 'application/json',}})
.then(response => {
    if (response.ok)
    return response.json();

    else
    return "ERooooR";  })  

.then(response => {
    
    if (response[0])
    SetDepartments(response);

    else
    console.log("Data Error . . . !");
    
    })  
.catch(er => {
        console.log("Fetch Error");
    });



fetch(host+"/GetData/GetShifts",{
method: 'GET',
headers: { 'Content-Type': 'application/json',}})
.then(response => {
    if (response.ok)
    return response.json();

    else
    return "ERooooR";  })  

.then(response => {
    
    if (response[0])
    SetShifts(response);

    else
    console.log("Data Error . . . !");
    
    })  
.catch(er => {
        console.log("Fetch Error");
    });



fetch(host+"/GetData/GetPersonnels",{
method: 'GET',
headers: { 'Content-Type': 'application/json',}})
.then(response => {
    if (response.ok)
    return response.json();

    else
    return "ERooooR";  })  

.then(response => {
    

    if(response){

        if (!Persennols[0]) Persennols = response;

    }else
    console.log("Data Error . . . !");
    
    })  
.catch(er => {
        console.log("Fetch Error");
    });



SetWorkHours();

SetTableRequests();
SetTable();
setTimeout(SetTable,500);

}

function exit(){
  
    document.cookie.split(";").forEach(cookie => {
        document.cookie = cookie.split("=")[0]+ "=;"
    })
  
    window.location = host+"/SingIn";

}


function showreq(){

    document.querySelector("table.main").style.display = "none";
    document.querySelector("table.myrequests").style.display = "table";

    document.querySelector("div#main_btn").style.display = "none";
    document.querySelector("div#back_btn").style.display = "flex";
       
    document.querySelector("div.info div#main_select").style.display = "none"
    document.querySelector("div.info div#req_select").style.display = "flex"
       

}
function back(){

document.querySelector("p.dep").innerHTML="برنامه پرسنل بخش";

document.querySelector("div#main_btn").style.display = "flex";
document.querySelector("div#back_btn").style.display = "none";

document.querySelector("table.main").style.display = "table";
document.querySelector("table.myrequests").style.display = "none";

document.querySelector("div.info div#main_select").style.display = "flex"
document.querySelector("div.info div#req_select").style.display = "none"
       
       
}
