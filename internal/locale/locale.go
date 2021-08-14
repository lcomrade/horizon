/*
   Copyright 2021 Leonid Maslakov

   License: GPL-3.0-or-later

   This file is part of Horizon.

   Horizon is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Horizon is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Horizon.  If not, see <https://www.gnu.org/licenses/>.

*/
package locale

import(
	"../build"
	"os"
)

var Lang string = ""

// cmd/horizon.go
var Server_listen = "Server listen"
var Server_use_TLS = "Server use TLS"
var CERT_file_does_not_exist = "CERT file does not exist"
var KEY_file_does_not_exist = "KEY file does not exist"

// internal/settings.go
var Load_file = "Load file"
var Env_var_is_empty = "environment variable is empty"
var Dir_flag = "Specifies the custom directory"
var Config_dir_flag = "Specifies the custom directory with configuration files"
var Version_flag = "Display version and exit"

var Go_top_tmpl = "Go top"
var Name_tmpl = "Name"
var Size_tmpl = "Size"
var Mode_tmpl = "Mode"
var ModTime_tmpl = "Modification time"
var Owner_tmpl = "Owner"
var Group_tmpl = "Group"

func getTranslate(){
	if Lang == "ru"{
		// cmd/horizon.go
		Server_listen = "Сервер слушает"
		Server_use_TLS = "Сервер использует TLS"
		CERT_file_does_not_exist = "Файл сертификата не найден"
		KEY_file_does_not_exist = "Файл ключа не найден"

		// internal/settings.go
		Load_file = "Файл загружен"
		Env_var_is_empty = "переменная окружения пуста"
		Dir_flag = "Указывает директорию"
		Config_dir_flag = "Указывает директорию с конфигурационными файлами"
		Version_flag = "Напечатать версию и выйти"

		Go_top_tmpl = "Вверх"
		Name_tmpl = "Название"
		Size_tmpl = "Размер"
		Mode_tmpl = "Права"
		ModTime_tmpl = "Время модификации"
		Owner_tmpl = "Владелец"
		Group_tmpl = "Группа"
		
		return
	}
}

func init() {
	locale := os.Getenv(build.LangEnvVar)

	for _, char := range locale[:] {
		charTmp := string(char)
		
		if charTmp == "." {
			break
		}

		if charTmp == "_" {
			break
		}

		Lang = Lang+charTmp
	}

	getTranslate()

}
