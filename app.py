from flask import Flask,render_template,request,redirect,url_for,flash,jsonify
import mysql.connector as sql
from mysql.connector import IntegrityError
from datetime import timedelta,date
from khayyam import JalaliDate

app = Flask(__name__)

DBconfig = {
    'host': '127.0.0.1',
    'user': 'shiftdata',
    'password': 'shift1403',
    'database': 'datashift'
}

CURRENT_WEEKDATE = None
WEEKDATE = dict()
Personnels = dict()

def GetUser(username,password):
    with sql.connect(**DBconfig) as con:
        cursor = con.cursor()
        cursor.execute(
            "SELECT isAdmin,name,PersonnelID FROM personnel where username = %s and password = %s",(username,password))
        User = cursor.fetchone()
        cursor.close()
        return User


# def WeekDate(saturday : datetime.date):
#     week = [saturday,
#             saturday+timedelta(days=1),
#             saturday+timedelta(days=2),
#             saturday+timedelta(days=3),
#             saturday+timedelta(days=4),
#             saturday+timedelta(days=5),
#             saturday+timedelta(days=6),
#             ]
#     return week

# def GetWeekShifts():
#     last_sat_date = None
#     ret = None
#     with sql.connect(**DBconfig) as con:
#         cursor = con.cursor()
#         cursor.execute("""
#         SELECT 
#     MAX(shiftassignments.date) - INTERVAL (SELECT 
#             MAX(log.day)
#         FROM
#             shiftassignments AS log
#         WHERE
#             log.date = (SELECT 
#                     MAX(log.date)
#                 FROM
#                     shiftassignments AS log)) DAY
# FROM
#     shiftassignments
#      """)

#         last_sat_date = cursor.fetchone()

#         if last_sat_date[0]:
#             cursor.execute("""
#             SELECT 
#         p.name,
#         pos.name,
#         p.contractType,
#         GROUP_CONCAT(CASE
#                 WHEN log.day = 0 THEN shifts.type
#             END) AS sat,
#         GROUP_CONCAT(CASE
#                 WHEN log.day = 1 THEN shifts.type
#             END) AS sun,
#         GROUP_CONCAT(CASE
#                 WHEN log.day = 2 THEN shifts.type
#             END) AS mon,
#         GROUP_CONCAT(CASE
#                 WHEN log.day = 3 THEN shifts.type
#             END) AS tue,
#         GROUP_CONCAT(CASE
#                 WHEN log.day = 4 THEN shifts.type
#             END) AS wed,
#         GROUP_CONCAT(CASE
#                 WHEN log.day = 5 THEN shifts.type
#             END) AS thu,
#         GROUP_CONCAT(CASE
#                 WHEN log.day = 6 THEN shifts.type
#             END) AS fri,
#         log.DepartmentsID , p.username
#     FROM
#         shiftassignments AS log
#             JOIN
#         personnel AS p ON (log.PersonnelID = p.PersonnelID)
#             JOIN
#         shifts ON (log.ShiftsID = shifts.ShiftsID)
#             JOIN
#         datashift.positions AS pos ON (p.positionID = pos.PositionsID)
#     WHERE
#         log.date BETWEEN %s AND (SELECT 
#                 MAX(log.date)
#             FROM
#                 shiftassignments AS log)
#     GROUP BY p.name , pos.name , p.contractType , log.DepartmentsID , p.username
#             ORDER BY p.isAdmin DESC;"""
#             ,(last_sat_date))

#             ret = cursor.fetchall()
#             cursor.close()

#             global CURRENT_WEEKDATE
#             CURRENT_WEEKDATE = WeekDate(last_sat_date[0])
                
#             UpdateUsers()

#         else:
#             today = JalaliDate.today()
#             last_sat_date = today - timedelta(today.weekday())

        
#     return ret





def WeekDate(saturday : date):
    week = [saturday,
            saturday+timedelta(days=1),
            saturday+timedelta(days=2),
            saturday+timedelta(days=3),
            saturday+timedelta(days=4),
            saturday+timedelta(days=5),
            saturday+timedelta(days=6),
            ]
    return week


def GetWeekShifts(WeekNum):
    last_sat_date = None
    ret = None

    with sql.connect(**DBconfig) as con:
        cursor = con.cursor()
        cursor.execute("""
        SELECT 
    MAX(shiftassignments.date) - INTERVAL (SELECT 
            MAX(log.day)
        FROM
            shiftassignments AS log
        WHERE
            log.date = (SELECT 
                    MAX(log.date)
                FROM
                    shiftassignments AS log)) DAY
FROM
    shiftassignments
     """)

        last_sat_date = cursor.fetchone()[0]
        cursor.close()

        if not last_sat_date:
            today = date.today()
            weekday = JalaliDate.today().weekday()
            last_sat_date = today - timedelta(weekday)

        global CURRENT_WEEKDATE
        CURRENT_WEEKDATE = WeekDate(last_sat_date)
        last_sat_date = last_sat_date + timedelta(WeekNum * 7)
        last_fri_date = last_sat_date + timedelta(6)

        cursor = con.cursor()
        cursor.execute("""
            SELECT 
        p.name,
        pos.name,
        p.contractType,
        GROUP_CONCAT(CASE
                WHEN log.day = 0 THEN shifts.type
            END) AS sat,
        GROUP_CONCAT(CASE
                WHEN log.day = 1 THEN shifts.type
            END) AS sun,
        GROUP_CONCAT(CASE
                WHEN log.day = 2 THEN shifts.type
            END) AS mon,
        GROUP_CONCAT(CASE
                WHEN log.day = 3 THEN shifts.type
            END) AS tue,
        GROUP_CONCAT(CASE
                WHEN log.day = 4 THEN shifts.type
            END) AS wed,
        GROUP_CONCAT(CASE
                WHEN log.day = 5 THEN shifts.type
            END) AS thu,
        GROUP_CONCAT(CASE
                WHEN log.day = 6 THEN shifts.type
            END) AS fri,
        log.DepartmentsID , p.username
    FROM
        shiftassignments AS log
            JOIN
        personnel AS p ON (log.PersonnelID = p.PersonnelID)
            JOIN
        shifts ON (log.ShiftsID = shifts.ShiftsID)
            JOIN
        datashift.positions AS pos ON (p.positionID = pos.PositionsID)
    WHERE
        log.date BETWEEN %s AND %s
    GROUP BY p.name , pos.name , p.contractType , log.DepartmentsID , p.username
            ORDER BY p.isAdmin DESC;"""
            ,(last_sat_date,last_fri_date))

        ret = cursor.fetchall()
        cursor.close()

        if not ret:
            ret = ["noData"]
            
        UpdateUsers()
        
    return ret


def UpdateUsers():
    
    with sql.connect(**DBconfig) as con:
        cursor = con.cursor(dictionary=True)
        cursor.execute("SELECT * FROM datashift.personnel;")
        per = cursor.fetchall()
        cursor.close()
        for p in per:
            Personnels.update({p["username"] : p})


def GetHourWorkState():

    with sql.connect(**DBconfig) as con:
        cursor = con.cursor(dictionary=True)
        cursor.execute("""
SELECT 
    CASE
        WHEN log.PersonnelID IS NULL THEN 0
        ELSE SUM(shifts.time)
    END AS worktime,
    CASE
        WHEN log.PersonnelID IS NULL THEN 0 - p.workinghours
        ELSE SUM(shifts.time) - p.workinghours
    END AS state,
    p.username,
    p.workinghours
FROM
    shiftassignments AS log
        JOIN
    shifts ON (shifts.ShiftsID = log.ShiftsID)
        RIGHT JOIN
    personnel AS p ON (log.PersonnelID = p.PersonnelID)
GROUP BY p.username;
""")
        ret = cursor.fetchall()
        cursor.close()
        return ret



positions = []
@app.route("/SaveUser",methods= ["POST"])
def saveuser():

    data = request.form
    workinghours = 0
    PositionsID = int(data.get("PositionsID"))
    try:
        if data.get("contractType") == "official" and positions:
            for pos in positions:
                 if pos["PositionsID"] == PositionsID:
                    workinghours = pos["standardWorkingHours"]
                    break
        else:
            workinghours = data.get("workinghours")

        with sql.connect(**DBconfig) as con:
            cursor = con.cursor()
            params = (data.get("name"),data.get("contractType"),workinghours,PositionsID,data.get("username"),data.get("password"))
            cursor.execute("INSERT INTO personnel (name, contractType, workinghours, positionID, isAdmin, username, password) VALUES (%s,%s,%s,%s,0,%s,%s);",params)
            con.commit()
            cursor.close()

    except IntegrityError as e:
        if "personnel.username_UNIQUE" in str(e):
            return ["uniqueError"],200
        

    return ["ok"], 200





@app.route("/SetData/<key>",methods= ["POST"])
def setdata(key):

    status = []

    if key == "SingInCHeck":
        data = request.get_json()
        if data:
            try:
                user = GetUser(data[0],data[1])
            except:
                return ["databaseerror"],200
            if user:
                user = list(user)
                return user,200
            else:
                return ["nouser"],200
        return ["nodata"], 200
    

    elif key == "GetTable":
        WeekNum = request.get_json()[0]
        data = GetWeekShifts(WeekNum)
        return data,200


    elif key == "SaveRequest":
        data = request.get_json()

        if not CURRENT_WEEKDATE : return ["nodate"],200

        with sql.connect(**DBconfig) as con:

            for req in  data:
                cursor = con.cursor()
                params = (req["UserID"],req["DepartmentsID"],req["type"],req["day"],req["commit"],str(req["status"]),CURRENT_WEEKDATE[int(req["day"])],)
                cursor.execute("INSERT INTO requests (PersonnelID, DepartmentsID, type, day, commit, status, date) VALUES (%s,%s,%s,%s,%s,%s,%s);",params)
                con.commit()
                cursor.close()
        


    elif key == "GetRequests":
        user = request.get_json()[0]
        with sql.connect(**DBconfig) as con:
            cursor = con.cursor()
            cursor.execute("""
    SELECT 
        requests.type,
        requests.status AS shift,
        requests.day,
        requests.DepartmentsID,
        requests.commit,
        requestlog.status
    FROM
        requests
            JOIN
        requestlog ON requests.RequestID = requestlog.RequestID
    WHERE
        requests.PersonnelID = %s;  """,(user,))
                
            data = cursor.fetchall()
            cursor.close()
        
        return data,200


    elif key == "ChangeRequest":
        data = request.get_json()
        Type = data["type"] 
        with sql.connect(**DBconfig) as con:
            cursor = con.cursor()
            cursor.execute("UPDATE requestlog SET status = %s ,adminAction = %s WHERE (RequestlogID = %s);",
                            (data["status"],data["adminAction"],data["RequestlogID"],))
            con.commit()
            cursor.close()

        if data["status"] == "accept" :
        
            if Type == "get":
                with sql.connect(**DBconfig) as con:
                    cursor = con.cursor()
                    cursor.execute("SET SQL_SAFE_UPDATES = 0;")
                    params =  (CURRENT_WEEKDATE[int(data["day"])],data["day"],Personnels[data["username"]]["PersonnelID"],data["DepartmentsID"],)
                    cursor.execute("""
        DELETE log FROM shiftassignments AS log
        WHERE
            log.date = %s
            AND log.day = %s
            AND log.PersonnelID = %s
            AND log.DepartmentsID = %s
            AND log.ShiftsID = 0;
                                """,params)
                                
                    con.commit()
                    cursor.close()


                    cursor = con.cursor()
                    params =  (Personnels[data["username"]]["PersonnelID"],data["ShiftsID"][0],data["DepartmentsID"],CURRENT_WEEKDATE[int(data["day"])],data["day"],)
                    cursor.execute("INSERT INTO shiftassignments (PersonnelID,ShiftsID,DepartmentsID,date,day) VALUES (%s,%s,%s,%s,%s);"
                                ,params)
                    
                    con.commit()
                    cursor.close()

            elif Type == "remove":
                with sql.connect(**DBconfig) as con:
                    cursor = con.cursor()
                    cursor.execute("SET SQL_SAFE_UPDATES = 0;")
                    params =  (CURRENT_WEEKDATE[int(data["day"])],data["day"],Personnels[data["username"]]["PersonnelID"],data["DepartmentsID"],data["ShiftsID"][0],)
                    cursor.execute("""
        DELETE log FROM shiftassignments AS log
        WHERE
            log.date = %s
            AND log.day = %s
            AND log.PersonnelID = %s
            AND log.DepartmentsID = %s
            AND log.ShiftsID = %s;
                                """,params)
                                
                    con.commit()
                    cursor.close()
                    

            elif Type == "change":
                with sql.connect(**DBconfig) as con:
                        cursor = con.cursor()
                        cursor.execute("SET SQL_SAFE_UPDATES = 0;")
                        params =  (CURRENT_WEEKDATE[int(data["day"])],data["day"],Personnels[data["username"]]["PersonnelID"],data["DepartmentsID"],data["ShiftsID"][0],)
                        cursor.execute("""
            DELETE log FROM shiftassignments AS log
            WHERE
                log.date = %s
                AND log.day = %s
                AND log.PersonnelID = %s
                AND log.DepartmentsID = %s
                AND log.ShiftsID = %s;
                                    """,params)
                                    
                        con.commit()
                        cursor.close()
                    
                        cursor = con.cursor()
                        params =  (Personnels[data["username"]]["PersonnelID"],data["ShiftsID"][1],data["DepartmentsID"],CURRENT_WEEKDATE[int(data["day"])],data["day"],)
                        cursor.execute("INSERT INTO shiftassignments (PersonnelID,ShiftsID,DepartmentsID,date,day) VALUES (%s,%s,%s,%s,%s);"
                                    ,params)
                        
                        con.commit()
                        cursor.close()


                
            elif Type == "off":
                with sql.connect(**DBconfig) as con:
                        cursor = con.cursor()
                        cursor.execute("SET SQL_SAFE_UPDATES = 0;")
                        params =  (CURRENT_WEEKDATE[int(data["day"])],data["day"],Personnels[data["username"]]["PersonnelID"],data["DepartmentsID"],)
                        cursor.execute("""
            DELETE log FROM shiftassignments AS log
            WHERE
                log.date = %s
                AND log.day = %s
                AND log.PersonnelID = %s
                AND log.DepartmentsID = %s;
                                    """,params)
                                    
                        con.commit()
                        cursor.close()


                        cursor = con.cursor()
                        params =  (Personnels[data["username"]]["PersonnelID"],0,data["DepartmentsID"],CURRENT_WEEKDATE[int(data["day"])],data["day"],)
                        cursor.execute("INSERT INTO shiftassignments (PersonnelID,ShiftsID,DepartmentsID,date,day) VALUES (%s,%s,%s,%s,%s);"
                                    ,params)
                        
                        con.commit()
                        cursor.close()



    elif key == "SaveShift":
   
        data = request.get_json()
        shifts = data[1]
        data = data[0]
        
        with sql.connect(**DBconfig) as con:
                cursor = con.cursor()
                cursor.execute("SET SQL_SAFE_UPDATES = 0;")
                params =  (CURRENT_WEEKDATE[int(data["day"])],data["day"],Personnels[data["username"]]["PersonnelID"],data["selectValue"],)
                cursor.execute("""
    DELETE log FROM shiftassignments AS log
    WHERE
        log.date = %s
        AND log.day = %s
        AND log.PersonnelID = %s
        AND log.DepartmentsID = %s;
                            """,params)
                
                con.commit()
                cursor.close()

        for sh in shifts:
            with sql.connect(**DBconfig) as con:
                cursor = con.cursor()
                params =  (Personnels[data["username"]]["PersonnelID"],int(sh),data["selectValue"],CURRENT_WEEKDATE[int(data["day"])],data["day"],)
                cursor.execute("INSERT INTO shiftassignments (PersonnelID,ShiftsID,DepartmentsID,date,day) VALUES (%s,%s,%s,%s,%s);"
                            ,params)
                
                con.commit()
                cursor.close()

 
    elif key == "ChangeAdmin":
        data = request.get_json()
        with sql.connect(**DBconfig) as con:
            cursor = con.cursor()
            cursor.execute("UPDATE personnel SET isAdmin = %s WHERE (username = %s);",
                        (not data[0],data[1],))
            print((not data[0],data[1],))
            con.commit()
            cursor.close()


    elif key == "":
        pass        
    elif key == "":
        pass        
    elif key == "":
        pass        



     
    return status,200




@app.route("/GetData/<key>",methods= ["GET"])
def getdata(key):

    data = []

    if key == "GetTable":
        data = GetWeekShifts(0)


    elif key == "GetDepartment":
        with sql.connect(**DBconfig) as con:
            cursor = con.cursor(dictionary=True)
            cursor.execute("SELECT  * FROM departments;")
            data = cursor.fetchall()
            cursor.close()
    elif key == "GetShifts":
        with sql.connect(**DBconfig) as con:
            cursor = con.cursor(dictionary=True)
            cursor.execute("SELECT * FROM shifts;")
            data = cursor.fetchall()
            cursor.close()

    elif key == "GetPositions":
        global positions
        with sql.connect(**DBconfig) as con:
            cursor = con.cursor(dictionary=True)
            cursor.execute("SELECT * FROM positions;")
            positions = cursor.fetchall()
            data = positions
            cursor.close()
    
    elif key == "GetHourWorkState":
        data = GetHourWorkState()


    elif key == "GetRequestsForAdmin":
        with sql.connect(**DBconfig) as con:
            cursor = con.cursor()
            cursor.execute("""
SELECT 
    requests.type,
    requests.status AS shift,
    requests.day,
    requests.DepartmentsID,
    requests.commit,
    requestlog.status,
    personnel.name,
    personnel.username,
    requestlog.RequestlogID
                           
FROM
    requests
        JOIN
    requestlog ON requests.RequestID = requestlog.RequestID
        JOIN
    personnel ON requests.PersonnelID = personnel.PersonnelID;  """)
            
            data = cursor.fetchall()
            cursor.close()


    elif key == "GetPersonnels":
        data = Personnels

    elif key == "":
        pass        
    elif key == "":
        pass        
    elif key == "":
        pass   

    
    return data,200



@app.route("/SingIn")
def singn():
    return render_template("singin.html")


@app.route("/SingUp")
def singup():
    return render_template("singup.html")


@app.route("/")
def main():
    return render_template("main.html")


@app.route("/Admin")
def admin():
    return render_template("admin.html")



if __name__=="__main__":
    app.run(debug=True)