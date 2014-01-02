"use strict"

db      = require "mysql-promise"
{check} = require "validator"
q       = require "q"


db.configure
  host:     'localhost'
  user:     'bitcamp'
  password: process.env.DB_PASSWORD
  database: 'bitcamp'


exports.bitcamp = (req, res) ->
  res.json
    bitcamp: true


exports.signup = (req, res) ->
  q(req.body).then ({email}) ->
    email if check(email).isEmail()
  .then (email) ->
    db.query('SELECT email FROM signup WHERE email="?"', email)
  .spread (rows) ->
    if rows.length is 0
      db.query('INSERT INTO signup SET ?', req.body)
    else null
  .fail (err) ->
    console.log err.message
    res.json 504, msg: "504"
  .done ->
    res.json 200, msg: "200"
