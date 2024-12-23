
const host = "http://127.0.0.1:5000";
var name;
var Username;
var UserID;
var isAdmin;
var AllShifts = {};
var MyShifts = [];
var AllHourWorks = null;
var MyHourWork;
var RequestData;
var Shifts = {};
var Departments = {};

(()=> {
    let data = GetCookie("data");
    if (!data)
    window.location = host+"/SingIn";
    else{
        data = JSON.parse(data);

        isAdmin = Boolean(data[0]);
        if (isAdmin) window.location = host+"/Admin";

        name = data[1];
        Username = GetCookie("username");
        UserID = data[2];
        
        document.querySelector("p.user").innerHTML = name;

        document.querySelector("div.savealert").classList.add("hide");
                
        document.querySelector("div.info div#req_select").style.display = "none"
        document.querySelector("form.request_popup").style.display = "none";
        document.querySelector("table.myshifts").style.display = "none";
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


function AddRow(table,data){

    const newRow = document.createElement("tr");

    data.forEach(cell => {
        const td = document.createElement("td");
        td.textContent = cell;
        if (cell == "رد شده") td.style.backgroundColor = "rgba(255, 140, 140, 0.699)";
        else if (cell == "تایید شده") td.style.backgroundColor = "rgba(103, 255, 154, 0.699)";
        newRow.appendChild(td);
    })

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



var lastSiftsState;
function AddRequest(){

const form = document.querySelector("form.request_popup");
form.style.display = "none";

const commit = form.querySelector("input.req_text").value

if (RequestData){


    let newState = [];
    form.querySelectorAll("input.ch").forEach(ch=>newState.push(ch.checked));
    
    if(JSON.stringify(newState) == JSON.stringify(lastSiftsState)){
        RequestData = null;
        lastSiftsState = null;
        return;    }


    let types = [];
    let type = null;
    let requests = [];
    lastSiftsState.forEach((last,i)=>{

        if(last && !newState[i])
        types.push("off");
        else if( !last && newState[i])
        types.push("get");

    });

    if (!(newState.includes(true)) && types.includes("off"))
    type ="off";
    else if(types.includes("off") && types.includes("get"))
    type ="change";
    else if(types.includes("off"))
    type = "remove";
    else if(types.includes("get"))
    type = "get";

    
    //Set Requests

    if (type == "off")
    requests.push({"type" : type,"UserID" : UserID,"DepartmentsID" : RequestData[0], "day" : RequestData[1], "commit" : commit ,"status" : []});
   
    else if (type == "change"){
        
    let s1 = null,s2 = null;
    lastSiftsState.forEach((last,i)=>{
    if(last && !newState[i]){
    if (s1)
    requests.push({"type": "remove" ,"UserID" : UserID,"DepartmentsID" : RequestData[0], "day" : RequestData[1], "commit" : commit ,"status" : [i+1]});
    else
    s1 = i+1;}
    else if( !last && newState[i]){
    if (s2)
    requests.push({"type" : "get" ,"UserID" : UserID,"DepartmentsID" : RequestData[0], "day" : RequestData[1], "commit" : commit ,"status" : [i+1]});
    else
    s2 = i+1;}

    });
    requests.push({"type" : "change","UserID" : UserID,"DepartmentsID" : RequestData[0], "day" : RequestData[1], "commit" : commit ,"status" : [s1,s2]});
    
   
    }else if (type == "get"){

    lastSiftsState.forEach((last,i)=>{
    if( !last && newState[i])
    requests.push({"type" : "get" ,"UserID" : UserID,"DepartmentsID" : RequestData[0], "day" : RequestData[1], "commit" : commit ,"status" : [i+1]});
    });     }

    else if (type == "remove"){

    lastSiftsState.forEach((last,i)=>{
    if(last && !newState[i])
    requests.push({"type": "remove" ,"UserID" : UserID,"DepartmentsID" : RequestData[0], "day" : RequestData[1], "commit" : commit ,"status" : [i+1]});
    });     }


    SaveRequest(requests);
    SetTableRequests();
    setTimeout(SetTableRequests,1000);

    RequestData = null;
    lastSiftsState = null;
}

}

function SaveRequest(data){

    fetch(host+"/SetData/SaveRequest",{
        method: "POST",
        headers:{
            'Content-Type': 'application/json',},
        body : JSON.stringify(data)
    })
    .then(response=>{
        if(response.ok)
            showAlert(document.querySelector("div.savealert"));
        else
        console.log("Save Request ERooooR");  }) 
        
    .catch(er => {
        console.log("Fetch Error");
    });

}


var no_clickEvent_r = true;
function requesthandler(state,day){

const DepartmentsID = document.querySelector("select.dep").value;
RequestData =[DepartmentsID,day.id];

const form = document.querySelector("form.request_popup");
form.style.display = "flex";

form.querySelector("input.req_text").value ="";

let dayShifts = [];

    form.querySelectorAll("input.ch").forEach(ch=>{
        ch.checked = false;
        if(state.textContent.includes(ch.id))
        ch.checked = true;
        
        dayShifts.push(ch.checked)
    })


    lastSiftsState = dayShifts;

if(no_clickEvent_r){
document.addEventListener("click",(event)=>{

if(!(form.contains(event.target) || event.target.tagName == "TD"))
form.style.display = "none";

});

no_clickEvent_r =false;     }

}


function SetTableMyShifts(dep,data){

if(!data)
return;
    
const my_table = document.querySelector("table."+"myshifts");
let my_tbody = my_table.querySelector("tbody");
my_tbody.remove();
my_tbody = document.createElement("tbody");
my_table.appendChild(my_tbody);

let nul = true;
for(let row of data){
let d = row.pop();
if(d==dep.value){
nul = false;
AddRow(my_tbody,MyHourWork.concat(row));
break;}    }

if(nul)
AddRow(my_tbody,MyHourWork.concat([null,null,null,null,null,null,null]));

if (my_tbody){
    const weekDates = JSON.parse(AllShifts[0])[1]["miladi"];
    const tbody = new Date;

    let tr = my_tbody.querySelectorAll("td");
    let headers = my_table.querySelectorAll("thead th")
    tr.forEach((td,i) => {
        if (headers[i].className=="day"){
        const day_date = weekDates[headers[i].id];
        const day_date_js = new Date(day_date[0],day_date[1]-1,day_date[2]);

        if(day_date_js.getTime() >= tbody.getTime()){
        td.addEventListener("click",()=>{requesthandler(td,headers[i])});
        td.style.backgroundColor = "rgba(131, 255, 193, 0.849)";
        td.addEventListener("mouseenter",()=>{td.classList.add("tdhoverefect"); })
        td.addEventListener("mouseleave",()=>{td.classList.remove("tdhoverefect"); })
    }}

    });
}


}


function SetTableRequests(st = "current"){


  
const my_table = document.querySelector("table."+"myrequests");
let my_tbody = my_table.querySelector("tbody");
my_tbody.remove();
my_tbody = document.createElement("tbody");
my_table.appendChild(my_tbody);
    
fetch(host+"/SetData/GetRequests",{
method: 'POST',
headers: { 'Content-Type': 'application/json',},
body: JSON.stringify([UserID])})
.then(response => {
    if (response.ok)
    return response.json();

    else
    return "ERooooR";  })  

.then(response => {
    if (response[0]){
    for(req of response){

        if (st == "current" && req[5]!= "current")
        continue;
        else if (st == "checked" && req[5] == "current")
        continue;

        let status = JSON.parse(req[1]);
        let row = [
                (req[0]=="get")?"افزودن":(req[0]=="remove")?"حذف":(req[0]=="change")?"تغیر":(req[0]=="off")?"مرخصی":"",
                (req[0]=="get")?Shifts[status[0]]:(req[0]=="remove")?Shifts[status[0]]:(req[0]=="change")?Shifts[status[0]]+" ⭢ "+Shifts[status[1]]:"",
                (req[2]==="0")?"شنبه":(req[2]==="1")?"یکشنبه":(req[2]==="2")?"دوشنبه":(req[2]==="3")?"سه‌شنبه":(req[2]==="4")?"چهارشنبه":(req[2]==="5")?"پنجشنبه":(req[2]==="6")?"جمعه":"",
                Departments[req[3]],
                req[4],
                (req[5] == "current")?"جاری":(req[5] == "reject")?"رد شده":(req[5] == "accept")?"تایید شده":""
            ];

        AddRow(my_tbody,row);
    }

    }else
    console.log("Data Error . . . !");
    
    })  
.catch(er => {
        console.log("Fetch Error");
    });


}




function beforeWeek(){
    const WeekHead = document.querySelector("table.WeekChange");
    WeekHead.id = Number(WeekHead.id)-1;
    SetTable();
}

function afterWeek(){
    const WeekHead = document.querySelector("table.WeekChange");
    if (Number(WeekHead.id) >= 1) return;

    WeekHead.id = Number(WeekHead.id)+1;
    SetTable();
}



function SetTable(){

const WeekHead = document.querySelector("table.WeekChange");
let Week = Number(WeekHead.id);

const table = document.querySelector("table."+"main");
let tbody = table.querySelector("tbody");
tbody.remove();
tbody = document.createElement("tbody");
table.appendChild(tbody);

const my_table = document.querySelector("table."+"myshifts");
let my_tbody = my_table.querySelector("tbody");
my_tbody.remove();
my_tbody = document.createElement("tbody");
my_table.appendChild(my_tbody);


if (AllShifts[Week]){
    const dep = document.querySelector("select.dep");
    const all = JSON.parse(AllShifts[Week]);

    WeekHead.querySelector("th.mid").innerHTML = all[1]["shamsi"][6][0]+" / "+all[1]["shamsi"][6][1]+" / "+all[1]["shamsi"][6][2] +"&nbsp;&nbsp;  -  &nbsp;&nbsp;"+all[1]["shamsi"][0][0]+" / "+all[1]["shamsi"][0][1]+" / "+all[1]["shamsi"][0][2];
    
    if (all[0][0] != "noData"){

    all[0].forEach(row => {
        row.pop(); 
        let user_dep = row.pop(); 
        row[2] = (row[2] == "hourly"?"ساعتی":row[2] == "official"? "رسمی" : row[2])
        if (user_dep == dep.value)
        AddRow(tbody,row);      });
    
        let myshifts = JSON.stringify(MyShifts);
        SetTableMyShifts(dep,JSON.parse(myshifts)); }

}else{
    
fetch(host+"/SetData/GetTable",{
    method: 'POST',
headers: { 'Content-Type': 'application/json',},
body : JSON.stringify([Week])})

.then(response => {
    if (response.ok)
    return response.json();

    else
    return "ERooooR";  })  

.then(response => {
    
    let dep = document.querySelector("select.dep");
    
    if (response[0]){
        WeekHead.querySelector("th.mid").innerHTML = response[1]["shamsi"][6][0]+" / "+response[1]["shamsi"][6][1]+" / "+response[1]["shamsi"][6][2] +"&nbsp;&nbsp;  -  &nbsp;&nbsp;"+response[1]["shamsi"][0][0]+" / "+response[1]["shamsi"][0][1]+" / "+response[1]["shamsi"][0][2];
    
    if (response[0][0] == "noData")
        AllShifts[Week] = JSON.stringify(response);

    else {
    AllShifts[Week] = JSON.stringify(response);
    
    response[0].forEach(row => {
        const username = row.pop(); 
        
        if (Username==username && Week === 0)
        MyShifts.push(row.slice(3));

        let user_dep = row.pop(); 
        row[2] = (row[2] == "hourly"?"ساعتی":row[2] == "official"? "رسمی" : row[2])
        if (user_dep == dep.value)
        AddRow(tbody,row);
    });


    try{
    let myshifts = JSON.stringify(MyShifts);
    SetTableMyShifts(dep,JSON.parse(myshifts));
    }catch{
    console.log("Error in set my shift table.");}
    }

    }else
    console.log("Data Error . . . !");
    
    })  
.catch(er => {
        console.log("Fetch Error");
    });

}
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



fetch(host+"/GetData/GetHourWorkState",{
method: 'GET',
headers: { 'Content-Type': 'application/json',}})
.then(response => {
    if (response.ok)
    return response.json();

    else
    return "ERooooR";  })  

.then(response => {
    
    if (response[0]){

        for(let user of response){
        if(user["username"]==Username){
        MyHourWork = [user["worktime"],user["state"]];
        break;} }

    AllHourWorks = response;}

    else
    console.log("Data Error . . . !");
    
    })  
.catch(er => {
        console.log("Fetch Error");
    });

SetTableRequests();
// SetTable();
setTimeout(SetTable,500);

}

function exit(){
  
    document.cookie.split(";").forEach(cookie => {
        document.cookie = cookie.split("=")[0]+ "=;"
    })
  
    window.location = host+"/SingIn";

}

function showMyShifts(){

document.querySelector("p.dep").innerHTML="شیفت های بخش";

document.querySelector("table.WeekChange").style.display = "none";
document.querySelector("table.main").style.display = "none";
document.querySelector("table.myshifts").style.display = "table";

document.querySelector("div#main_btn").style.display = "none";
document.querySelector("div#back_btn").style.display = "flex";


}


function showreq(){

    document.querySelector("table.main").style.display = "none";
    document.querySelector("table.WeekChange").style.display = "none";
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

document.querySelector("table.WeekChange").style.display = "table";
document.querySelector("table.main").style.display = "table";
document.querySelector("table.myshifts").style.display = "none";
document.querySelector("table.myrequests").style.display = "none";

document.querySelector("div.info div#main_select").style.display = "flex"
document.querySelector("div.info div#req_select").style.display = "none"
       
       
}