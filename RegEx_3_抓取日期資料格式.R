##################################
####   Regular Expressions    ####
####        Exercises         ####
##################################

## 抓取日期資料格式(mm/dd/yy)
# CASE 1
(data_str = c("02/22/16",
         "02-22-16",
         "02.22.16"))

##  填入你的Regex in ____
grep('____', data_str, value=TRUE)


# grep('02.22.16', data_str, value=TRUE)



# CASE 2
(data_str = c("02/22/16",
             "02-22-16",
             "02.22.16",
             "02-22616000"))

##  填入你的Regex in ____
grep('____', data_str, value=TRUE)


# grep('02[-./]22[-./]16', data_str, value=TRUE)



# CASE 3
(data_str = c("02/22/16",
             "02-22-16",
             "02.22.16",
             "02-22616000",
             "06/18/16"))
##  填入你的Regex in ____
grep('____', data_str, value=TRUE)


# grep('[0-9]{2}[-./][0-9]{2}[-./]16', data_str, value=TRUE)



# CASE 4
(data_str = c("02/22/16",
             "02-22-16",
             "02.22.16",
             "02-22616000",
             "06/18/16",
             "202.22.161.7"))
##  填入你的Regex in ____
grep('____', data_str, value=TRUE)


# grep('^[0-9]{2}[-./][0-9]{2}[-./]16$', data_str, value=TRUE)
# grep('^(0[0-9]|1[12])[-./]([012][0-9]|3[01])[-./]16$', data_str, value=TRUE)


