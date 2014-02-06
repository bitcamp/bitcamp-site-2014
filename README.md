bitca.mp
========

36-hour hackathon at University of Maryland.

The website hosted at http://bitca.mp/.


## Run it on your machine

1. Fork this repo.
2. Clone it to your machine  
    > git clone git@github.com:$USER/bitca.mp.git
3. Setup a MySQL server.
  * Create a user called bitcamp.
  * Create a database called 'bitcamp' 
  * Create a table in 'bitcamp' called 'signup' that looks like this:  
    ; id(int):key | name(string) | email(string) | university(string)
4. Install dependencies:  
    > cd bitca.mp && npm i  
    > npm install -g grunt-cli
5. Start her up in development mode:  
    > DB_PASSWORD=foobar grunt serve
6. Head to http://localhost:8000/


## Code with us

1. Fork this repo.
2. Clone it and make make a new branch.
3. Write some code, commit, and push.
4. Probably do step #3 a few more times.
5. Send a Pull Request.
