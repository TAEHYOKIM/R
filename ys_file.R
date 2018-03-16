#ó�� R�� �����ϱ� ���� �ؾ�����
#1. JAVA_HOME ȯ�溯�� �����ϱ�
#2. r selenium ���������(http://hmtb.tistory.com/5) <- ����Ʈ ���� �����ϱ�
#3. 2������ ���� �� �ֿܼ� ���� ���� ���� ��Ű��. ���� ����Ʈ���� �Ѱ�ó��(cmd setup)
#4. ���� ���� �� �Ʒ� �ڵ带 ������ ����


install.packages("RSelenium")
library(RSelenium) #selenium ���̺귯�� �ҷ�����
remDr <- remoteDriver(remoteServerAddr = "localhost", port= 4445L, browserName ="chrome") #�ֿܼ� ��� ���� ���� �ڵ带 ������ �ֱ�
remDr$open() #ũ�� ������ ����
remDr$navigate("http://race.kra.co.kr/dbdata/textData.do?Act=11&Sub=1&meet=1") # ���ϴ� ����Ʈ�� �����ϱ� �ּҿ� ���ϴ� �ּҸ� ������ �ȴ�.
#���� �����̰� ���ϴ� �渶�ڷ����Ʈ�� �־���.

#���ָ� ��ũ ��ü ã���
webElem0 <- remDr$findElement(using = "xpath", "//*[@id='contents']/ul/li[3]/ul/li[1]/a")
#ã�� ��ü Ŭ�� -> �ش� ��ũ�� �̵�
webElem0$clickElement()


library(rvest)
#�̸� ���� ������ �ֱ�
kfile <- NULL
kfile1 <- NULL
kfile3 <- NULL
#10���� ��µǴ� �������� 16�� �ѱ�鼭 �� ���������� �����ִ� ���ϸ��� �����´�.
for(j in 1:16){
  
  #���� ������ ������ 1~10�������� �ִ� ���� 1���� �����´�.  i�� 3���� �����ϴµ� 1�� ������ ��ü������ 3�������̴�.
  for(i in 3:13){
    
    # ���������� ����Ʈ�� ����ش�. �α� Ȯ�ο�
    ifelse(i == 13, print("1������"),print(paste(i-2,"������"))) 
    
    #1~10�������� ��ü�� �ϳ��� ã�´�. ������ ���� i�� ǥ��
    webElem11 <- remDr$findElement(using = "xpath", value= paste("//*[@id='inputVo']/div[2]/a[",i,"]", sep=""))
    #ã�Ƽ� Ŭ�����ش�.
    webElem11$clickElement()
    #�ε��ð��� ���� 2�� �����̸� �ش�
    Sys.sleep(2)
    
    #�ش� �������� �ִ� ���ϸ����� �����´�.
    source<-remDr$getPageSource()[[1]]
    #HTML�� �о�´�.
    html <- read_html(source)
    
    #�ߺ��Ǵ� ���ϸ��� ���ֱ� ���� ���� ����
    kfile1 <- kfile 
    #kfile�� ���ϸ����� �־��ش�.
    kfile <- html_nodes(html, css ="td >a")%>%html_text() 
    #�α׿����� �Ʒ� ����Ʈ���� �����ش�.
    print(paste("������:",kfile1[1]))
    print(paste("���ݰ�:",kfile[1]))
    #���� �ҷ��� ���ϸ��� ������ �ҷ��Դ� ���ϸ��� ���Ͽ� ������ �������� �ʰ�, �ٸ��� ���ο� ������ �������� �����Ѵ�.
    ifelse(kfile1[1] == kfile[1], print("����������"), kfile3 <-rbind(kfile3, kfile))
  }
}
#��ü ũ�Ѹ��ؿ� ���ϸ� ��������
kfile3
#CSV���Ϸ� ����
write.csv(kfile3, file = 'c:\\r\\race.csv', row.names=F)


#�� ���ϸ� ���� ���� ������ ���� ���캸��
length(kfile3[,1]) #151��
length(kfile3[1,]) #10��

#ù��° ���ϸ� Ȯ��
kfile3[1,1]

#kfile3�� �̿��Ͽ� ���ָ� ���� ��������, kfile3 ù������ ����ִ� ���ϸ����� ������ ����!
grade <- readLines(paste('http://race.kra.co.kr/dbdata/fileDownLoad.do?fn=internet/seoul/horse/', kfile3[1,1], sep=""))

#�� �����ߴ��� Ȯ���غ���
grade

#Ȯ�� �Ϸ� �� ���� ��Ȱ���� ���� ��ó���� ������
grade<- NULL

#������ ������ ���Ÿ� ���� csv���Ͽ� ������ ���� �ٵ� ���� �ϳ��ϳ� �����ϴµ� ���� �ɸ��ϱ� �߰��߰� �����̸� �� �ɾ��
#10���� 151���� ������ 2�������� �� ��������
#ù��° ������ ��ü ������ ������ kfile3[,i]�� ������.
for(i in 1:length(kfile3[,1])){
  #�ι�° ������ �� ������ 10���� ���� �ִ�. �׷��� 10���� ��������
  for(j in 1:10){
    #���� ������ ���鼭 �ش� �ּ��� �ؽ�Ʈ�� grade�� ��������
    grade <- readLines(paste('http://race.kra.co.kr/dbdata/fileDownLoad.do?fn=internet/seoul/horse/', kfile3[i,j], sep=""))
    #������ ����� �����ؼ� �����غ���, ������ �ֱ⿡�� �ʹ� ���ݾ�?
    write.table(grade, file = 'c:\\r\\race_data.csv', sep=",", row.names=FALSE, col.names=FALSE, quote=FALSE, append = T)
    print(paste((152-i)*10-j, "��° �Ϸ�!", sep=""))
  }
  print("=================================================")
}

#race_data.csv ������ �뷮�� 318�ް� ��������
#�� ������ �̿��ؼ� �м��ϸ� �ɵ�

text <- read.table("http://race.kra.co.kr/dbdata/fileDownLoad.do?fn=internet/seoul/horse/20180204sdb1.txt")
head(text)