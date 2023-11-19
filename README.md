# LogIngestor
This is a simple log ingestor made using erlang.
Steps to compile-
brew install rebar3 if rebar3 is not present in your system
clone the repository
to compile
first compile the libraries
rebar3 get-deps
now compile using rebar3 compile
to open an erlang shell use
rebar3 shell 
now start the application by entering
log_ingestor_app:start(normal,[]).
this will start the app and the localhost will now listen for incoming logs
the endpoint is /ingest
curl -X POST -H "Content-Type: application/json" -d '{
    "level": "error",
    "message": "Failed to connect to DB",
    "resourceId": "server-1234",
    "timestamp": "2023-09-15T08:00:00Z",
    "traceId": "abc-xyz-123",
    "spanId": "span-456",
    "commit": "5e5342f",
    "metadata": {
        "parentResourceId": "server-0987"
    }
}' http://localhost:3000/ingest
this is an example of how the system takes in the input and writes it to example.txt 
And after ingestion is complete there is a response on the shell that says log text received
The project has a ui par which is log_filter.html
the filtering part is not completed yet and is in progress but this is what is done till now

