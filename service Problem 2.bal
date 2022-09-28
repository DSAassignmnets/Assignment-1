import ballerina/graphql;

// define data type in table
public type CovidEntry record {|
  string date;
  string region;
  int deaths;
  int Confirmed_cases;
  int recoveries;
  int tested;
|};

// Now we define the data table
table<CovidEntry> covidEntriesTable = table [
    {date: "12/09/2021", region: "Khomas", deaths: 39, Confirmed_cases: 465, recoveries: 67, tested: 1200}
];

// Now we define the the object type, we define the CovidData object type

public distinct service class CovidData {
    private final readonly & CovidEntry entryRecord;

    function init(CovidEntry entryRecord) {
        self.entryRecord = entryRecord.cloneReadOnly();
    }

    resource function get date() returns string {
       return self.entryRecord.date; 
    }
    resource function get region() returns string {
        return self.entryRecord.region;
    }
    resource function get deaths() returns int? {
        if self.entryRecord.deaths is int{
            return self.entryRecord.deaths;
        }
    }
    resource function get Confirmed_cases() returns int? {
        if self.entryRecord.Confirmed_cases is int{
            return self.entryRecord.Confirmed_cases;
        }
    }
    resource function get recoveries() returns int? {
        if self.entryRecord.recoveries is int{
            return self.entryRecord.recoveries;
        }
    }
     resource function get tested() returns int? {
        if self.entryRecord.tested is int{
            return self.entryRecord.tested;
        }
    }
}

// Now we create the GraphQL service
// the path of the service is defined as /covid19

service /covid19 on new graphql:Listener(9000) {
    //this returns all fields as an array of the CovidData type
    resource function get all() returns CovidData[] {
        CovidEntry[] covidEntries = covidEntriesTable.toArray().cloneReadOnly();
        return covidEntries.map(entry => new CovidData(entry));
    }
    // This is a mutation field a query, a remote method to add
    //entry to the data source

    remote function add(CovidEntry entry) returns CovidData {
        covidEntriesTable.add(entry);
        return new CovidData(entry);
    }
}