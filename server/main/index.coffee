path               = require "path"

{check}            = require "validator"
q                  = require "q"

{db, email_server} = require "../"

{permissionSlip}   = require "../util/emails"



exports.bitcamp = (req, res) ->
  res.json
    bitcamp: true


exports.signup = (req, res) ->

  {email, name} = req.body

  q(req.body).then ({email}) ->
    email if check(email).isEmail()

  .then (email) ->
    db.query "SELECT email FROM signup WHERE email=?", email

  .spread (rows) ->
    if rows.length is 0
      db.query "INSERT INTO signup SET ?", req.body
    else true

  .then ->
    d = q.defer()
    email_server.send
      from:           "Bitcamp <bitcamp@bitca.mp>"
      to:             email
      subject:        "Permission Slip Received!"
      text:           permissionSlip(name)
      "Content-Type": "text/html; charset=utf-8"
    , (err, data) ->
      if err then d.reject err else d.resolve()
    return d

  .then ->
    res.json 200, msg: "200"

  .fail (err) ->
    console.log err.message
    res.json 400, msg: "400"

  .done()


exports.schools = (req, res) ->
  res.json require('../util/schools')

