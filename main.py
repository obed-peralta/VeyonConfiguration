from flask import Flask,request,jsonify
import db


app = Flask(__name__)
     
@app.route("/<type>/<name>/<host>/<mac>/<location>")
def main(type,name,host,mac,location):
    result = db.Database().InsertPC(type,name,host,mac,int(location))
    if result:
        return jsonify({'response':'Added'})
    else:
        
        return jsonify({'response':'No added'})

if __name__ == "__main__":
    app.run(port=3000, debug=True, host="192.168.8.23")