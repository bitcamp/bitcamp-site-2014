bitca.mp
========

36-hour hackathon at University of Maryland.

The website hosted at http://bitca.mp/.


## Run it on your machine

1. Fork this repo.
2. Clone it to your machine  
    `git clone git@github.com:$USER/bitca.mp.git`
3. Install dependencies:  
    `cd bitca.mp; npm i && bower i`  
    `npm install -g grunt-cli`
4. Start her up in development mode:  
    `grunt serve`
5. Head to http://localhost:8000/

### P.S.
You'll have to setup and run the backend,
[ember](https://github.com/bitcamp/ember), seperately.  Either use nginx or
apache (or something) serve both of these projects in development mode, or run
the `grunt` command to produce a fully compiled frontend in the ./public
folder, and make `ember` serve that.


## Code with us

1. Fork this repo.
2. Clone it and make make a new branch.
3. Write some code, commit, and push.
4. Probably do step #3 a few more times.
5. Send a Pull Request.



[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/bitcamp/bitca.mp/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

