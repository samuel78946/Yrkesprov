from flask import Flask, render_template
import sqlite3


app = Flask(__name__)

sql = "SELECT \
            kustannus_name,\
            kustannus_id,\
            SUM(euro_brutto),\
            rank()over(order by SUM(euro_brutto) DESC)\
            from avoin\
            group by kustannus_id\
	       limit 5"

@app.route("/")
def home():
   conn = sqlite3.connect('/var/www/gunicorn/avoin.db')
   c = conn.cursor()
   c.execute(sql)
   data = c.fetchall()
   conn.close()

    #labels == [row[0] for row in data]
    #values == [row[1] for row in data]
   labels = []
   values = []

   for row in data:
        labels.append(row[0])
        values.append(row[2])

   return render_template("graph.html", labels=labels, values=values)
   #return data
   if __name__ == ' __main__':
        app.run(port=8000, debug=true)
