from khayyam import JalaliDate
from datetime import timedelta,datetime,date

# # print(khayyam.JalaliDate(1403,6,12).todate())
# today = khayyam.JalaliDate.today()
# weekday = khayyam.JalaliDate.today().weekday()
# print(today-datetime.timedelta(5))


# gregorian_date = datetime.datetime(2023, 12, 23)
# jalali_date = khayyam.JalaliDate(gregorian_date)


# print(jalali_date)
today = date.today()
weekday = JalaliDate.today().weekday()
last_sat_date = today - timedelta(weekday)



last_sat_date = last_sat_date + timedelta(0 * 7)
last_fri_date = last_sat_date + timedelta(6)

print(last_sat_date,last_fri_date)
