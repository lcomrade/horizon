# config.json (file)
## File example
```
{
  "HttpServer": {
    "Listen":    ":8080",
    "EnableTLS": false,
    "CertFile":  "",
    "KeyFile":   ""
  },
  "Logging": {
  	"Level": "Info",
  	"LogRequest": true,
  	"Log404Request": true
  },
  "ShowHiddenFiles": false,
  "HumanFileSize": true,
  "ModTimeFormat": "2006 Jan 2 15:04"
}
```

## HTTP server
### Listen
Specifies the **port and ip** address that the server is listening to (default: `":8080"`).

```
{
  "HttpServer": {
    "Listen": ":8080"
  }
}

```

### Enable TLS
`EnableTLS` - enables TLS encryption (default: `false`)

`CertFile` - specify the path to the certificate file (default: `""`)

`KeyFile` - specify the path to the key file (default: `""`)

```
{
  "HttpServer": {
    "EnableTLS": true,
    "CertFile": "/etc/ssl/cert",
    "KeyFile": "/etc/ssl/key"
  }
}

```

## Logging
`Level` - specifies the events to be logged. Possible values: `Info`, `Warning`, `Error` (default: `"Info"`)
`LogRequest` - logs all successful requests (default: `true`)
`Log404Request` - logs all 404 error requests (default: `true`)

```
{
  "Logging": {
  	"Level": "Info",
  	"LogRequest": true,
  	"Log404Request": true
  }
}
```

## Web Interface
### Show hidden files
Does not display files that begin with a dot. If the file or directory name is entered correctly, it can still be used (default: `false`).

```
{
  "ShowHiddenFiles": false
}

```

### Human readable file size
Displays file sizes in human-readable format. For example: `4096=4K`, `5200000=5M` (default: `true`).

```
{
  "HumanFileSize": true
}

```

### Modification time format
Sets the custom date and time format of the modification. Learn more about the date and time format in GO: [src/time/format.go](https://golang.org/src/time/format.go) (default: `"2006 Jan 2 15:04"`).

```
{
  "ModTimeFormat": "2006 Jan 2 15:04"
}

```

# index.tmpl (file)
If you want to write your own HTML page template, use the [GO documentation](https://pkg.go.dev/html/template). The example below shows the default template.
## File example
```
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>{{.Path}} - Horizon</title>
  </head>
  <body>
    <h2>{{.Path}}</h2>
    <p><a href={{.UpPath}}>Go top</a></p>
    <table align='left' border=1 cellpadding=5>
      <th align='left'>Name</th>
      <th align='left'>Size (bit)</th>
      <th align='left'>Mode</th>
      <th align='left'>Modification time</th>
      <th align='left'>Owner</th>
      <th align='left'>Group</th>
      {{range .Files}}
        <tr>
          <td><a href={{.Path}}>{{.Name}}</a></td>
          <td>{{.Size}}</td>
          <td>{{.Mode}}</td>
          <td>{{.ModTime}}</td>
          <td>{{.Owner}} ({{.Uid}})</td>
          <td>{{.Group}} ({{.Gid}})</td>
        </tr>
      {{end}}
    </table>
  </body>
</html>
```

# resources (dir)
Contains custom resources that will be available but will not appear in the file list. For example it can be used for CSS styles or favicon.ico.
