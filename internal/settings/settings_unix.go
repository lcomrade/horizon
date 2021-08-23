// Copyright 2021 Leonid Maslakov

// License: GPL-3.0-or-later

// This file is part of Horizon.

// Horizon is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// Horizon is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Horizon.  If not, see <https://www.gnu.org/licenses/>.

// +build aix dragonfly freebsd js,wasm linux netbsd openbsd solaris

package settings

import(
	"../locale"
)

//Default template
var templateDefault =
	`<!doctype html>
<html>
	<head>
		<meta charset="utf-8">
		<title>{{.Path}} - Horizon</title>
	</head>
	<body>
		<h2>{{.Path}}</h2>
		<p><a href={{.UpPath}}>` + locale.Go_top_tmpl + `</a></p>
		<table align='left' border=1 cellpadding=5>
			<th align='left'>` + locale.Name_tmpl + `</th>
			<th align='left'>` + locale.Size_tmpl + `</th>
			<th align='left'>` + locale.Mode_tmpl + `</th>
			<th align='left'>` + locale.ModTime_tmpl + `</th>
			<th align='left'>` + locale.Owner_tmpl + `</th>
			<th align='left'>` + locale.Group_tmpl + `</th>

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
</html>`
