# config.json
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
  	"Level": "Info"
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
`Level` - specifies the events to be logged. Possible values: `Info`, `Warning`, `Error` (default: `Info`)

```
{
  "Logging": {
  	"Level": "Info"
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
