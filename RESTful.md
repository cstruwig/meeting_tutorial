# RESTful API standards

## HTTP verbs and URI syntax

### verbs (full list [here](https://annevankesteren.nl/2007/10/http-methods))

```GET``` - used for reading

```POST``` - used for creation

```PUT``` - used for updates

```DELETE``` - used for deletes

> **Note:** ```PATCH``` and ```POST``` are also used for updates in certain scenarios

### syntax 

```HTTP Verb /URI```

> **Note:** the ```HTTP body``` contains the data for the request
	
### standard RESTful call examples

#### select

```GET /contact/``` : returns all contacts

```GET /contact/{{contact_id}}``` : returns the contact matching the supplied id

```GET /contact/?external_ref={{other_ref}}``` : returns the contact(s) matching external_ref
	
```GET /contact/?name={{name}}``` : returns the contact(s) matching on name
	
```GET /contact/?status={{status}}&date={{date}}``` : returns the contact(s) matching on status and date

#### insert

```POST /contact``` : inserts a new contact

#### update

```PUT /contact``` : updates "the entire" contact record with unique id (in payload)

```POST /contact/{{contact_id}}``` : updates the entire contact record for the contact id (in querystring)

```PATCH /contact``` : updates the partial contact for the unique id and fields (in request)

```PATCH /contact/{{id}}``` : updates the partial contact for the unique id and fields (in querystring)

#### delete

```DELETE /contact/{{contact_id}}``` : deletes a contact with the specified id

### **custom** RESTful call examples

## custom operations

```GET /contact/deceased/``` selects a custom dataset of deceased contacts

```GET /contact/weekly_report/?date={{last_run_date}}}``` select custom dataset filtering on date



