from flask import Flask, render_template
# De här importerar flask classen och render_template functionen från flask modulen. 

import sqlite3
#Den här importerar sqlite3 modulen. Som tillhanderar python interface till sqlite database engine.

app = Flask(__name__)
#Den här coden tilldelar flask till variebeln 'app'

sql = "SELECT \
            kustannus_name,\
            kustannus_id,\
            SUM(euro_brutto),\
            rank()over(order by SUM(euro_brutto) DESC)\
            from avoin\
            group by kustannus_id\
	       limit 5"
# Den här  definierar en SQL-query som väljer namn, ID och totala bruttointäkter för de 5 bästa kostnadsställena från en SQLite-databastabell med namnet avoin.

@app.route("/")
def home():
#Den här raden definierar en ny Flask-rutt som mappar root-URL-adressen ("/") till home functionen
	
   conn = sqlite3.connect('/var/www/gunicorn/avoin.db')
   c = conn.cursor()
   c.execute(sql)
   data = c.fetchall()
   conn.close()
#Den här skapar en ny sqlite databas anslutning


    #labels == [row[0] for row in data]
    #values == [row[1] for row in data]

   labels = []
   values = []
   for row in data:
        labels.append(row[0])
        values.append(row[2])
# Den här  kodblock skapar två listor, Labels och values.

   return render_template("graph.html", labels=labels, values=values)
# Den här raden returnerar en renderad HTML-Template som heter graph.html,
	
   if __name__ == ' __main__':
        app.run(port=8000, debug=true)
# Den här startar Flask-applikationen på port 8000 och med debug mode aktiverat.
	
