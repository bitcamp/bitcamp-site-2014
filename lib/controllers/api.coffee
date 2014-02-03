{check} = require "validator"
q       = require "q"

{db}    = require "../server"


exports.bitcamp = (req, res) ->
  res.json bitcamp: true


exports.signup = (req, res) ->
  {email} = req.body
  q(req.body).then ({email}) ->
    email if check(email).isEmail()
  .then (email) ->
    db.query "SELECT email FROM signup WHERE email=?", email
  .spread (rows) ->
    if rows.length is 0
      db.query "INSERT INTO signup SET ?", req.body
    else true
  .then ->
    res.json 200, msg: "200"
  .fail (err) ->
    console.log err.message
    res.json 400, msg: "400"
  .done ->
    console.log "Signup success!"


exports.schools = (req, res) ->
  res.json require '../util/schools'

