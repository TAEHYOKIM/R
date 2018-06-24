#check
.libPaths()
Sys.getenv()
library(rJava)
library(SparkR)

#경로에 추가
.libPaths(c(Sys.getenv('SparkR'),.libPaths()))

#SparkR 다운
#install.packages('SparkR')
library(SparkR, lib.loc = Sys.getenv('SparkR'))

## ex.01
sc <- sparkR.session(master="local[*]", appName = "HBK", sparkConfig = list(spark.driver.memory="2g"))
sqlContext <- sparkRSQL.init(sc)
df <- createDataFrame(sqlContext, iris) 
head(df)
help("Deprecated") 

## ex.02
iris1 <- as.DataFrame(iris)
showDF(iris1)

sparkR.session.stop()


## ex.03
#dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_172.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
#library(rJava)
library(dplyr)

#install.packages("sparklyr")
library(sparklyr)
?spark_connect

sc <- spark_connect(master = 'local', app_name = 'sparklyr')
sc

#install.packages("nycflights13")
library(nycflights13)

#spark로 data 전달
flights_tbl <- copy_to(sc, nycflights13::flights, "flights")
flights_tbl

spark_disconnect(sc)


## 비교
sparkR.session(master="local[*]", appName = "HBK", sparkConfig = list(spark.driver.memory="2g"))
a <- as.DataFrame(flights)
head(a)
sparkR.session.stop()
