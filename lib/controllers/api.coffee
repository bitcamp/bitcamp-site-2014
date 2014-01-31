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
  {email} = req.body
  q(req.body).then ({email}) ->
    email if check(email).isEmail()
  .then (email) ->
    db.query("SELECT email FROM signup WHERE email=?", email)
  .spread (rows) ->
    if rows.length is 0
      db.query('INSERT INTO signup SET ?', req.body)
    else true
  .fail (err) ->
    console.log err.message
    res.json 500, msg: "500"
  .done ->
    res.json 200, msg: "200"


exports.schools = (req, res) ->
  res.json require('../util/schools')

exports.fireside =
  blocks: (req, res) ->
    if not blocks.length
      do refreshBlocks
    res.json 200, blocks
