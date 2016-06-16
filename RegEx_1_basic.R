##################################
####   Regular Expressions    ####
##################################

#### 介紹RegEx基本語法

## 任意字元: .
(test_str <- c("hello world", "你好啊", "", "\n") )
grep('.', test_str, value=TRUE, perl=TRUE)
grep('.', test_str, value=TRUE, perl=FALSE) 


## 位置類: ^, $, \\<, \\>
(test_str <- c("hello world", "你好啊", "hihi", "word", "你好") )
# 限制句首
grep('^h', test_str, value=TRUE)
grep('^he', test_str, value=TRUE)
grep('^你', test_str, value=TRUE)

# 限制句尾
grep('d$', test_str, value=TRUE)
grep('world$', test_str, value=TRUE)
grep('好', test_str, value=TRUE)
grep('好$', test_str, value=TRUE)

# 限制字首
grep('^w', test_str, value=TRUE)
grep('\\<w', test_str, value=TRUE)

# 限制字尾
grep('o$', test_str, value=TRUE)
grep('o\\>', test_str, value=TRUE)


## 量詞類：*, +, ?, {, }
(test_str <- c("hello world", "helllo", "apple", "hihi", "heo"))
grep('l', test_str, value=TRUE)
grep('ll', test_str, value=TRUE)
# 限制出現次數
grep('l+', test_str, value=TRUE)  # 1 or many times
grep('l?', test_str, value=TRUE)  # 0 or 1 times
grep('l*', test_str, value=TRUE)  # 0 or many times
grep('l{2,3}', test_str, value=TRUE)
grep('l{3}', test_str, value=TRUE)
grep('l{2,}', test_str, value=TRUE)

## 群組類：[], (), |
(test_str <- c("hello world", "你好", "hihi", "0.0", "XDD","02-12345678"))
# class: []
grep("[ei]", test_str, value=TRUE)  # 包含e或是i
# 特殊範圍a-zA-Z0-9
grep("[a-z]", test_str, value=TRUE)
grep("[A-Z]", test_str, value=TRUE)
grep("[0-9]", test_str, value=TRUE)
grep("[a-zA-Z]", test_str, value=TRUE)
# mapping "-"
grep("[a-z-]", test_str, value=TRUE)
grep("[-a-z]", test_str, value=TRUE)
grep("[a-f]", test_str, value=TRUE)
# 反向查詢
grep("^h", test_str, value=TRUE)
grep("^[^h]", test_str, value=TRUE)

# grouper: ()
(test_str <- c("hello", "olleh", "hellohello"))
grep("^hello$", test_str, value=TRUE)
grep("^[hello]$", test_str, value=TRUE)
grep("^(hello)?$", test_str, value=TRUE)  # ?: means 0 or 1 times
grep("^(hello)+$", test_str, value=TRUE)  # +: means 1 or many times

# or:|
(test_str <- c("hello world", "你好", "hihi", "XDD","02-12345678"))
grep("^h|^你", test_str, value=TRUE)
grep("(hello|XD)", test_str, value=TRUE)


## 跳脫字元：\
(test_str <- c("[問卦]", "[你好]", "[]","^hihi", "2^10"))
grep("\\^", test_str, value=TRUE)
grep("\\[.*\\]", test_str, value=TRUE)  # *: means 0 or many times
grep("\\[.+\\]", test_str, value=TRUE)  # +: means 1 or many times

