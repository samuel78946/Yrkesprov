$source = 'https://www.avoindata.fi/data/dataset/d203038a-fa46-40b8-80b4-33479bf64412/resource/a71df935-054d-4e83-8e07-e2e15f6224ed/download/ostolaskudata-2021-porvoon-kaupunki.csv'
#källan, altså linken till infon filen man vill ha ner laddad
$destination = '/home/kenny/Documents/Yrkesprov/porvoo2.csv'
#vart man vill att filen skall sparas
$csvpath = "/home/kenny/Documents/Yrkesprov/porvoo2.csv"
$csvdelimiter = ";"
#Den tar bort semicolon och splitar texten


Invoke-WebRequest -Uri $source -OutFile $destination
#säger åt powershell att ta infon från den här sidan och sätt det på den här platsen



#importerar information in till powershell så man kan läsa och använda det
$file = Import-CSV -Path  $csvpath -Delimiter $csvDelimiter -Encoding UTF7



#Den lagar pathen vart databasen skall sparas 
$Database = "/home/kenny/Documents/Yrkesprov/porvoo2.db"

$kustid = $file.kustannuspaikka
$kustname = $file."kustannuspaikan nimi"
$tositenum = $file.tositenumero
$tositename = $file.tositelaji
$brutto = $file."EUR, brutto"
$rondo = $file."Rondo ID"


#den här lagar en tabell
$hash = @{kustid = $kustid; kustname = $kustname;tositenum = $tositenum; tositename = $tositename; brutto = $brutto; rondo = $rondo }


#bestämmer vilkAa värden som skall vara i raderna
$Query = "CREATE TABLE avoin (id INTEGER PRIMARY KEY, 

                               kustannus_id INTEGER,

                               kustannus_name text,

                               tosite_number INTEGER,

                               tositename text,

                               euro_brutto REAL,

                               rondo_id INTEGER 

                               );"




#Den här lagar databasen
Invoke-SqliteQuery -Query $Query -DataSource $Database


#Räknar mängden kust ID
0..$kustid.count | ForEach-Object{
    #$kustid.count 

    
    $mangd = $_

    $kid = $hash.kustid[$mangd]
    $kname = $hash.kustname[$mangd]
    $tnum = $hash.tositenum[$mangd]
    $tname = $hash.tositename[$mangd]
    $bronto = $hash.brutto[$mangd] -replace ",","." -replace " ",""
    #$bronto[$mangd]
    $rnd = $hash.rondo[$mangd]

    $Query = "INSERT INTO avoin (kustannus_id, kustannus_name, tosite_number, tositename, euro_brutto, rondo_id) VALUES ('$kid', '$kname', '$tnum', '$tname', '$bronto', '$rnd');"

        Invoke-SqliteQuery -Query $Query -DataSource $Database



    }
    #Den här spottar ut allt din data i en tabell
    $readit = Invoke-SqliteQuery -Query "select * from avoin;" -DataSource $Database
    $readit
