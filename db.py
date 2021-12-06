import pymysql


class Database:
    def __init__(self):
        self.connection = pymysql.connect(
            host="localhost", user="root", password="", db="pcs"
        )
        self.cursor = self.connection.cursor()

    def InsertPC(self, type, name, host, mac, location):
        sql = "insert into pcf%s values (%s, %s, %s, %s, %s)"
        try:
            self.cursor.execute(sql, (location,type, name, host, mac, location))
            self.connection.commit()
            return True
        except Exception as e:
            print(e)
            return False
    def ExportCSV(self, location):
        #sql = "SELECT name,host,mac,concat('F',location) as location FROM pcf%s INTO OUTFILE 'C:/Users/adano/Desktop/ServidorFlask/F%s.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n'"
        sql = "SELECT concat('F',location) as location,name,host,mac FROM pcf%s INTO OUTFILE 'C:/Users/adano/Desktop/ServidorFlask/F%s.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'"
        try:
            self.cursor.execute(sql,(location,location))
            self.connection.commit()
            return True
        except Exception as e:
            print(e)
            return False
        
