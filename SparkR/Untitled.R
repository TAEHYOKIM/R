.libPaths()


library(sparkR, lib.loc="/usr/local/Cellar/apache-spark/2.3.1/libexec")
library(SparkR)
install.packages("SparkR")
Sys.getenv('SPARK_HOME')
Sys.setenv(SPARK_HOME = )

install.packages("rJava")
library(rJava)

## 스파크가 설치된 환경정보를 받아온다.
spark_path <- strsplit(system("brew info apache-spark",intern=T)[4],' ')[[1]][1] 

## SparkR 라이브러리 디렉토리를 지정한다.
.libPaths(c(file.path(spark_path,"libexec", "R", "lib"), .libPaths())) 
.libPaths()
Sys.getenv()

## SparkR 라이브러리를 적재한다.
library(SparkR)
Sys.getenv()
library(SparkR, lib.loc = file.path(Sys.getenv("SPARK_HOME"), "R", "lib")) 
file.path(spark_path,'libexec')

Sys.setenv(SPARK_HOME='/usr/local/Cellar/apache-spark/2.3.1/libexec')
Sys.setenv(JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk1.8.0_172.jdk/Contents/Home')
library(SparkR)
Sys.getenv()
.libPaths()

sparkR.session(master="local[*]", appName = "HBK", sparkConfig = list(spark.driver.memory="2g"))
# sqlContext <- sparkRSQL.init(sc)
# df <- createDataFrame(sqlContext, iris) 
head(df)
help("Deprecated") 

iris1 <- as.DataFrame(iris)
showDF(iris1)
sparkR.session.stop()


library(rJava)

library(dplyr)

install.packages("sparklyr")
library(sparklyr)
?spark_connect
sc <- spark_connect(master = 'local', app_name = 'sparklyr')
sc

install.packages("nycflights13")
library(nycflights13)

flights_tbl <- copy_to(sc, nycflights13::flights, "flights")
flights_tbl

a = as.DataFrame(flights)
head(a)

sparkR.session.stop()
